from django.urls import path
from .views import UserDetailView, ProductCreateView, product, create_user, test_token, categories, user_login, logout_user, get_csrf_token

urlpatterns = [
    path('register/', create_user, name='register'),
    path('login/', user_login, name='login'),
    path('login/test_token/', test_token, name='Token Test'),
    path('logout/', logout_user, name='logout'),
    path('csrf_token/', get_csrf_token, name='csrf-token'),
    path('product/create/', ProductCreateView.as_view(), name='product-create'),
    path('product/categories/', categories, name='categories'),
    path('product/', product, name='Product'),
    
]