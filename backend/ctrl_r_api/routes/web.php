<?php

use App\Http\Controllers\web\AlertController;
use App\Http\Controllers\web\AuthController;
use App\Http\Controllers\web\ControleController;
use App\Http\Controllers\web\HomeController;
use App\Http\Controllers\web\UsersController;
use Illuminate\Support\Facades\Route;


Route::get("/", [AuthController::class, "login_page"])->name("login_page");
Route::post("/", [AuthController::class, "login"])->name("login");

// Routes protégées par le middleware auth
Route::middleware(['auth'])->group(function () {
    Route::get("/admin", [HomeController::class, "index"])->name("home_page");
    Route::get("/admin/register", [AuthController::class, "register_page"])->name("register_page");
    Route::post("/admin/register", [AuthController::class, "store"])->name("store");
    Route::get("/admin/users", [UsersController::class, "index"])->name("users_page");
    Route::get("/admin/user/controle/{id}", [UsersController::class, "user_controls"])->name("user_controls");
    Route::get("/admin/controle", [ControleController::class, "index"])->name("controle_page");
    Route::get("/admin/controle/delete", [ControleController::class, "delete_index"])->name("delete_index");
    Route::get("/admin/alert", [AlertController::class, "index"])->name("alert_page");
    Route::get('/logout', [AuthController::class, 'logout'])->name('logout');
});
