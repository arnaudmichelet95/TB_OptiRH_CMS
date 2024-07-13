from django.urls import path
from optirh_app import views
from .views import login_view, register_view, logout_view, simplifyTranslate_view

urlpatterns = [
    path("", views.home, name="home"),
    path('api/login/', login_view, name='login'),
    path('api/register/', register_view, name='register'),
    path('api/logout/', logout_view, name='logout'),
    path("api/simplifytranslate/", simplifyTranslate_view, name='simplify_translate'),
    
]
