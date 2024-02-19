from django.contrib import admin
from .models import Category, Product, PriceType

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    model=Category
    list_display=("id","name")

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    model=Product
    list_display=("id","name")

@admin.register(PriceType)
class PriceTypeAdmin(admin.ModelAdmin):
    model=PriceType
    list_display=("id","name")

# admin.site.register(Category, CategoryAdmin)

# Register your models here.
