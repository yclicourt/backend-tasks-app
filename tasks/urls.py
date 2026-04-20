from django.urls import path,include
from rest_framework import routers
from .views import TaskView
router = routers.DefaultRouter()

router.register(r'task',TaskView,'tasks')

urlpatterns = [
    path("api/v1/", include (router.urls)),
]