from django.urls import path
from optirh_app import views
from .views import login_view, register_view, logout_view, simplifyTranslate_view, summarize_view, request_history_view, summary_history_view

urlpatterns = [
    path("", views.home, name="home"),
    path('api/login/', login_view, name='login'),
    path('api/register/', register_view, name='register'),
    path('api/logout/', logout_view, name='logout'),
    path("api/simplifytranslate/", simplifyTranslate_view, name='simplify_translate'),
    path("api/summarizepf/", summarize_view, name='summarizepf'),
    path("api/requesthistory/", request_history_view, name='request_history'),
    path("api/summaryhistory/", summary_history_view, name='summary_history')
    
]
