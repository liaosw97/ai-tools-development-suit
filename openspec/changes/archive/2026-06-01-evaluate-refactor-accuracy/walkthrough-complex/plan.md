# Plan: complex-change

> 实施计划 — TDD 级别的详细步骤

---

## 批次一：订单处理

### Task 1.1: 实现订单创建 [spec:order-processing#订单创建]

- **文件**: `src/order.ts` (Create)
- **RED**: 编写失败测试
  ```typescript
  test('should create order', () => {
    expect(createOrder({ items: [] })).toBeDefined();
  });
  ```
- **运行验证失败**: `pnpm test`
- **GREEN**: 最小实现
  ```typescript
  export function createOrder(items: Item[]): Order {
    return { id: uuid(), items, status: 'created' };
  }
  ```
- **运行验证通过**: `pnpm test`

### Task 1.2: 实现支付处理 [spec:payment#支付处理]

- **依赖**: Task 1.1（订单创建）
- **文件**: `src/payment.ts` (Create)
- **RED**: 编写失败测试
  ```typescript
  test('should process payment', () => {
    expect(processPayment(orderId, amount)).toBe(true);
  });
  ```
- **运行验证失败**: `pnpm test`
- **GREEN**: 最小实现
  ```typescript
  export function processPayment(orderId: string, amount: number): boolean {
    return true;
  }
  ```
- **运行验证通过**: `pnpm test`

---

## 批次二：库存和通知

### Task 2.1: 实现库存管理 [spec:inventory#库存管理]

- **依赖**: Task 1.2（支付处理）
- **文件**: `src/inventory.ts` (Create)
- **RED**: 编写失败测试
  ```typescript
  test('should update inventory', () => {
    expect(updateInventory(itemId, quantity)).toBe(true);
  });
  ```
- **运行验证失败**: `pnpm test`
- **GREEN**: 最小实现
  ```typescript
  export function updateInventory(itemId: string, quantity: number): boolean {
    return true;
  }
  ```
- **运行验证通过**: `pnpm test`

### Task 2.2: 实现通知系统 [spec:notification#通知系统]

- **依赖**: Task 2.1（库存管理）
- **文件**: `src/notification.ts` (Create)
- **RED**: 编写失败测试
  ```typescript
  test('should send notification', () => {
    expect(sendNotification(orderId, 'order_created')).toBe(true);
  });
  ```
- **运行验证失败**: `pnpm test`
- **GREEN**: 最小实现
  ```typescript
  export function sendNotification(orderId: string, type: string): boolean {
    return true;
  }
  ```
- **运行验证通过**: `pnpm test`
