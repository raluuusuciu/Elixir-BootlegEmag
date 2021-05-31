export type FindShoppingCartResponse = {
    shoppingCart: FindShoppingCartResponseItem;
}

export type FindShoppingCartResponseItem = {
    userId: string,
    productIdQuantity: Record<string, number>
}