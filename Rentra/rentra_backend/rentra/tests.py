from django.test import TestCase
from .models import Product, Category

class TestProduct(TestCase):

    def setUp(self):
        cat = Category.objects.create(name='Test Category 1', completed=False)
        Product.objects.create(name='Test Product 1', description='test Desc', category_id=cat.id, price_type='hourly', price=100)
        Product.objects.create(name='Test Product 2', description='test Desc', category_id=cat.id, price_type='hourly', price=100)

    def test_Product_name(self):
        Product1 = Product.objects.get(title='Test Product 1')
        Product2 = Product.objects.get(title='Test Product 2')
        self.assertEqual(Product1.name, 'Test Product 1')
        self.assertEqual(Product2.name, 'Test Product 2')

    # def test_Product_completed(self):
    #     Product1 = Product.objects.get(title='Test Product 1')
    #     Product2 = Product.objects.get(title='Test Product 2')
    #     self.assertFalse(Product1.completed)
    #     self.assertTrue(Product2.completed)