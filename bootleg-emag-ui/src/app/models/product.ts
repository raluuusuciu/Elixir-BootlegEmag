export class Product {
    id : string;
    name: string;
    category: string;
    price: string;
    image: string;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}