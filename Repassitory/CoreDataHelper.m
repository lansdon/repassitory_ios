#import "CoreDataHelper.h"

#import "LRPUser.h"
#import "User.h"
#import "LRPAppState.h"


@interface CoreDataHelper ()


@end



@implementation CoreDataHelper

#pragma mark - Retrieve objects

// Fetch objects with a predicate
+(NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// If a sort key was passed then use it in the request
	if (sortKey != nil) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
    
	// Execute the fetch request
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// If the returned array was nil then there was an error
	if (mutableFetchResults == nil)
		NSLog(@"Couldn't get objects for entity %@", entityName);
    
	// Return the results
	return mutableFetchResults;
}

// Fetch objects without a predicate
+(NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self searchObjectsForEntity:entityName withPredicate:nil andSortKey:sortKey andSortAscending:sortAscending andContext:managedObjectContext];
}

#pragma mark - Count objects

// Get a count for an entity with a predicate
+(NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
	// If the count returned NSNotFound there was an error
	if (count == NSNotFound)
		NSLog(@"Couldn't get count for entity %@", entityName);
    
	// Return the results
	return count;
}

// Get a count for an entity without a predicate
+(NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self countForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}

#pragma mark - Delete Objects

// Delete all objects for a given entity
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// Ignore property values for maximum performance
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil) {
		for (NSManagedObject *manObj in fetchResults) {
			[managedObjectContext deleteObject:manObj];
		}
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;
}

+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self deleteAllObjectsForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}


#pragma mark - User/Records

+(User*)getUser:(LRPUser*)testUser {
    // Use users key
    [LRPAppState setKey:testUser.password];
        
	// Execute the count request
	NSArray *fetchResults = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]];
                              
//    NSLog(@"getUser --start");
    for(int i=0; i<fetchResults.count; ++i) {
//        NSLog(@"%@, %@, %@", [fetchResults[i] username], [fetchResults[i] password], [fetchResults[i] user_id]);
        if([[fetchResults[i] username] isEqualToString:testUser.username] &&
           [[fetchResults[i] password] isEqualToString:testUser.password]) {
            return fetchResults[i];
        }
    }
    return nil;
}


+ (int) getUniqueUserID {
    int newId = [CoreDataHelper countForEntity:@"User" andContext:[CoreDataHelper managedObjectContext]];
    return  newId + 1;
}

// Check if username is taken
+ (bool)usernameExistsByUser:(LRPUser*)testUser {

/*
    // Use users key
    [LRPAppState setKey:testUser.password];
    
	// Execute the count request
	NSArray *fetchResults = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]];
    
    for(int i=0; i<fetchResults.count; ++i) {
        if([[[fetchResults[i] username] lowercaseString] isEqualToString:[testUser.username lowercaseString]] &&
            [[[fetchResults[i] password] lowercaseString] isEqualToString:[testUser.password lowercaseString]]) {
            return true;
        }
    }
 */
    return [CoreDataHelper usernameExistsByString:testUser.username];
}

// Check if username is taken
+ (bool)usernameExistsByString:(NSString*)testUsername {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(username == %@)", testUsername];
    
    if ([CoreDataHelper countForEntity:@"User" withPredicate:pred andContext:[CoreDataHelper managedObjectContext]] <= 0) {
        return false;
    }
    return true;
}


+ (BOOL)createNewUserFromObject:(LRPUser*)newUser {
    // Must update user key prior to accessing core data!
    [LRPAppState setKey:newUser.password];

    NSLog(@"Creating user:%@, pass:%@, key:%@", newUser.username, newUser.password, [LRPAppState getKey]);

    // Check if username is taken
    if (![CoreDataHelper usernameExistsByUser:newUser]) {
        
        NSManagedObject *cdNewUser = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
        
        NSNumber* newID = [NSNumber numberWithInt:[CoreDataHelper getUniqueUserID]];
    
        [cdNewUser setValue:newUser.username forKey:@"username"];
        [cdNewUser setValue:newUser.password forKey:@"password"];
        [cdNewUser setValue:newID forKey:@"user_id"];
        [cdNewUser setValue:newUser.security_answer forKey:@"security_answer"];
        [cdNewUser setValue:newUser.security_question forKey:@"security_question"];
        
        [CoreDataHelper saveContext];
        
        return true;
    } else {
		NSLog(@"Create user:FAILED");
	}
    return false;
}

#pragma mark - Persistent Objects

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator* _persistentStoreCoordinator = nil;
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[CoreDataHelper applicationDocumentsDirectory] URLByAppendingPathComponent:@"MainStore.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[CoreDataHelper managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel* _managedObjectModel = nil;
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MainStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/**
 Returns the URL to the application's Documents directory.
 */
// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


 // Returns the managed object context for the application.
 // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)managedObjectContext
 {
     static NSManagedObjectContext* _managedObjectContext = nil;
     if (_managedObjectContext != nil) {
         return _managedObjectContext;
     }
 
     NSPersistentStoreCoordinator *coordinator = [CoreDataHelper persistentStoreCoordinator];
     if (coordinator != nil) {
         _managedObjectContext = [[NSManagedObjectContext alloc] init];
         [_managedObjectContext setPersistentStoreCoordinator:coordinator];
     }
     return _managedObjectContext;
 }
 
+ (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end