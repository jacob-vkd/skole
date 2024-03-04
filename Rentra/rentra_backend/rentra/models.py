from django.db import models
from django.contrib.auth.models import User

class Category(models.Model):
    name = models.CharField(max_length=255)
    
    class Meta:
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(null=True)
    category_id = models.ForeignKey('Category', on_delete=models.SET_NULL, null=True)
    price_type = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=6, decimal_places=1)
    image = models.ImageField(null=True, upload_to='images')
    user_id = models.ForeignKey(User, on_delete=models.CASCADE, default=None, null=True)
    rented_by_user_id = models.ForeignKey(User, on_delete=models.SET_NULL, default=None, null=True, related_name='rented_products')

class PriceType(models.Model):
    name = models.CharField(max_length=255)