from django.urls import path
from .views import RegistrationView, UserDetailView, ProductCreateView, categories, user_login, logout_user, get_csrf_token

urlpatterns = [
    path('register/', RegistrationView.as_view(), name='register'),
    path('user/', UserDetailView.as_view(), name='user-detail'),
    path('login/', user_login, name='login'),
    path('logout/', logout_user, name='logout'),
    path('csrf_token/', get_csrf_token, name='csrf-token'),
    path('product/create/', ProductCreateView.as_view(), name='product-create'),
    path('product/categories/', categories, name='categories'),
]