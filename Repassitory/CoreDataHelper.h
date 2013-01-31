#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class LRPUser;

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

// Load databases

+ (NSPersistentStoreCoordinator *)loadUserStore:(LRPUser*)user
            persistentStoreCoordinator:(NSPersistentStoreCoordinator*) persistentStoreCoordinator
                           managedObjectModel:(NSManagedObjectModel*)managedObjectModel;
 
+ (NSPersistentStoreCoordinator *)loadPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)persistentStoreCoordinator managedObjectModel:(NSManagedObjectModel *)managedObjectModel;

+ (NSManagedObjectModel *)managedObjectModel:(NSManagedObjectModel*)managedObjectModel;

+ (NSManagedObjectContext *)managedObjectContext:(NSManagedObjectContext*)managedObjectContext managedObjectModel:(NSManagedObjectModel*)managedObjectModel;

+ (NSURL *)applicationDocumentsDirectory;

// Static pointers


@end