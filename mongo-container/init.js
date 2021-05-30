let error = true

db.auth('root', 'example');

function createCollectionAndUser(databaseName) {
    database = db.getSiblingDB(databaseName);
    database.createUser(
        {
            user: 'root-user',
            pwd: 'password',
            roles: [{
                role: 'readWrite',
                db: databaseName
            }]
        }
    );
    database.createCollection(databaseName);
}


let res = [
    createCollectionAndUser('products'),
    createCollectionAndUser('users'),
    createCollectionAndUser('shoppingcart')
];