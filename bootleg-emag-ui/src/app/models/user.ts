export enum Role {
    Admin = 'ADMIN',
    Shopper = 'SHOPPER',
    Seller = 'SELLER'
}

export class User {
    name: string;
    password: string;
    role: string;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}