import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { BehaviorSubject, Observable, Subject } from "rxjs";
import { map, tap } from "rxjs/operators";
import { Product } from "../models/product";
import { ShoppingCart } from "../models/shopping-cart";
import { AuthService } from "./auth.service";
import { FindShoppingCartResponse } from "./http/shopping-cart-http-models";
import { ProductService } from "./product.service";

const API_URL = "https://localhost:44337/api/shoppingcart";

@Injectable({
    providedIn: "root",
})
export class ShoppingCartService {
    private products;
    shoppingCartQuery: BehaviorSubject<ShoppingCart> = new BehaviorSubject(null);

    constructor(
        private http: HttpClient,
        private productService: ProductService,
        private authService: AuthService
    ) {
        this.authService.user$.subscribe(user => {
            if (!user) {
                return;
            }

            this.query(user.name);
        });

        this.productService.getProducts().subscribe(products => {
            this.products = products;
        });
    }


    get shoppingCart(): Observable<ShoppingCart> {
        return this.shoppingCartQuery.asObservable();
    }

    query(userId: string): void {
        const queryPromise = this.http.get<FindShoppingCartResponse>(`${API_URL}/${userId}`).toPromise();
        
        queryPromise.then(response => {
            const mappedModel = this.mapResponseToModel(response)
            this.shoppingCartQuery.next(mappedModel);
        });
    }

    private mapResponseToModel(response: FindShoppingCartResponse): ShoppingCart {
        const responseShoppingCart = response.shoppingCart;
        const parsedProductsMap = new Map<Product, number>();

        Object.entries(responseShoppingCart.productIdQuantity).forEach(([key, value]) => {
            const product = this.productService.products.find(prod => prod.id === key);

            parsedProductsMap.set(product, value);
            console.log(product);
        });

        return {
            products: parsedProductsMap
        };
    }

    addItem(userId: string, productId: string): void {
        let requestBody = {
            UserId: userId,
            ProductId: productId,
            Quantity: 1
        };

        this.http.post(API_URL, requestBody).subscribe();
    }
}
