<?php

use App\Http\Controllers\AlertController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ControleController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/profile', [AuthController::class, 'updateProfile']);
    Route::get('/profiles', [AuthController::class, 'index']);
    Route::post('/password', [AuthController::class, 'updatePassword']);
    Route::post('/controls/add', [ControleController::class, 'addControl']);
    Route::post('/controls/fakeDelete/{id}', [ControleController::class, 'fakeDeleteControle']);
    Route::get('/controls', [ControleController::class, 'getControlsWithUser']);
    Route::get('/controls/search', [ControleController::class, 'searchControlByPlaque']);
    Route::get('/controls/filter', [ControleController::class, 'getFilteredControls']);
    Route::post('/alerts/add', [AlertController::class, 'addAlert']);
    Route::get('/alerts', [AlertController::class, 'getAlerts']);
    Route::delete('/alerts/delete/{id}', [AlertController::class, 'deleteAlert']);
});
Route::post('/register', [AuthController::class, 'store']);
Route::post('/login', [AuthController::class, 'login']);
