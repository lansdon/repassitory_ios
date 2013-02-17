#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class LRPUser;
@class User;

@interface CoreDataHelper : NSObject

// For retrieval of objects
+(NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;
+(NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;

// For deletion of objects
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andContext:(NSManagedObjectContext *)managedObjectContext;
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext;

// For counting objects
+(NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+(NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext;


// Core Data Objects
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSURL *)applicationDocumentsDirectory;
+ (void)saveContext;

// User Entity Functions
+ (BOOL)createNewUserFromObject:(LRPUser*)newUser;
+ (int) getUniqueUserID;
+ (bool)usernameExistsByUser:(LRPUser*)testUser;
+ (bool)usernameExistsByString:(NSString*)testUsername;
+(User*)getUser:(LRPUser*)testUser;


@end