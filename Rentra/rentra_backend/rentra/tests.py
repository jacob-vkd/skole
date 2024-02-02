from django.test import TestCase
from .models import Product

class TestProduct(TestCase):

    def setUp(self):
        Product.objects.create(title='Test Product 1', completed=False)
        Product.objects.create(title='Test Product 2', completed=False)

    def test_Product_title(self):
        Product1 = Product.objects.get(title='Test Product 1')
        Product2 = Product.objects.get(title='Test Product 2')
        self.assertEqual(Product1.title, 'Test Product 1')
        self.assertEqual(Product2.title, 'Test Product 2')

    def test_Product_completed(self):
        Product1 = Product.objects.get(title='Test Product 1')
        Product2 = Product.objects.get(title='Test Product 2')
        self.assertFalse(Product1.completed)
        self.assertTrue(Product2.completed)