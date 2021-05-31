import { ChangeDetectorRef, Component, OnInit, ViewEncapsulation } from '@angular/core';
import { PageEvent } from '@angular/material';
import { Router } from '@angular/router';
import { Product } from '../models/product';
import { AuthService } from '../services/auth.service';
import { ProductService } from '../services/product.service';
import { ShoppingCartService } from '../services/shopping-cart.service';

@Component({
	selector: 'app-product-list',
	templateUrl: './product-list.component.html',
	styleUrls: ['./product-list.component.scss'],
	encapsulation: ViewEncapsulation.None
})
export class ProductListComponent implements OnInit {
	products: Product[] = []
	lowValue: number = 0;
	highValue: number = 4;
	pageSize: number = 4;

	showContent = false;
	shoppingCartItems = 0;

	constructor(
		private productService: ProductService,
		private authService: AuthService,
		private shoppingCartService: ShoppingCartService,
		private router: Router,
		private changeDetectorRef: ChangeDetectorRef
	) { }

	ngOnInit() {
		this.productService.getProducts().subscribe(products => {
			this.products = products;
		});

		this.authService.user$.subscribe(() => {
			this.showContent = this.authService.isLoggedIn;
		});

		this.shoppingCartService.shoppingCart.subscribe(shoppingCart => {
			if (shoppingCart && shoppingCart.products) {
				this.shoppingCartItems = shoppingCart.products.size;
				this.changeDetectorRef.detectChanges();
			}
		});
		
	}

	pageChanged(event: PageEvent): PageEvent {
		this.lowValue = event.pageIndex * event.pageSize;
		this.highValue = this.lowValue + event.pageSize;
		return event;
	}

	addToShoppingCart(product: any): void {
		this.shoppingCartService.addItem(this.authService.user.name, product.id);
	}

	navigateToShoppingCart(): void {
		this.router.navigateByUrl('/shopping-cart');
	}

}
