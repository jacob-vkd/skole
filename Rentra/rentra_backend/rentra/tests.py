from django.test import TestCase
from .models import Product

class TestProduct(TestCase):

    def test_Product_completed(self):
        self.assertTrue(1==1)