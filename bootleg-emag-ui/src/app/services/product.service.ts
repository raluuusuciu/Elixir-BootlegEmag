import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { tap } from "rxjs/operators";
import { Product } from "../models/product";

const API_URL = "https://localhost:44337/api/product";

@Injectable({
	providedIn: "root",
})
export class ProductService {
	private _products: Product[] = [];

	constructor(private http: HttpClient) { }

	get products() {
		return this._products;
	}

	// API: GET/getallProd
	public getProducts(): Observable<Product[]> {
		return this.http.get<Product[]>(API_URL + "/getallProd").pipe(
			tap(products => this._products = products)
		);
	}
}
