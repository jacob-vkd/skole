from django.contrib import admin
from .models import Category

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    model=Category
    list_display=("id","name")

# admin.site.register(Category, CategoryAdmin)

# Register your models here.
