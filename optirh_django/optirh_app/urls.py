from django.urls import path
from optirh_app import views

urlpatterns = [
    path("", views.home, name="home"),
]