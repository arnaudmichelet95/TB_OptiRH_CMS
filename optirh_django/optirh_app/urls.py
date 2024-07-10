from django.urls import path
from optirh_app import views
from .views import simplifyTranslate_view

urlpatterns = [
    path("", views.home, name="home"),
    path("api/simplifytranslate/", simplifyTranslate_view, name='simplify_translate'),
]
