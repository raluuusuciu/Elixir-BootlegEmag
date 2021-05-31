import { AfterViewInit, ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { VirtualTimeScheduler } from 'rxjs';
import { ShoppingCartService } from 'src/app/services/shopping-cart.service';
import { ShoppingCartItemViewModel } from './shopping-cart-product-viewmodel';

@Component({
	selector: 'be-shopping-cart',
	templateUrl: './shopping-cart.component.html',
	styleUrls: ['./shopping-cart.component.scss']
})
export class ShoppingCartComponent implements AfterViewInit {
	shoppingCartProducts: ShoppingCartItemViewModel[] = [];

	constructor(
		private shoppingCartService: ShoppingCartService,
		private changeDetectorRef: ChangeDetectorRef
	) { }

	async ngAfterViewInit() {
		this.shoppingCartService.shoppingCart.subscribe(shoppingCart => {
			if (shoppingCart && shoppingCart.products) {
				shoppingCart.products.forEach((quantity, product) => {
					this.shoppingCartProducts.push({product: product, quantity: quantity});
			});
			}

			this.changeDetectorRef.detectChanges();
		});
	}

	checkout() {
		debugger;
	}
}
