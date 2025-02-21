from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    # todo.urls to ścieżka do pliku todo/urls.py
    path('', include('todo.urls')),
]
