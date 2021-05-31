import { Product } from "src/app/models/product";

export type ShoppingCartItemViewModel = {
    product: Product;
    quantity: number;
}