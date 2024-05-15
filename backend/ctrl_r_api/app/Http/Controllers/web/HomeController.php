<?php

namespace App\Http\Controllers\web;

use App\Http\Controllers\Controller;
use App\Models\Control;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
    // Récupérer les 10 derniers contrôles ajoutés
    $controles = Control::join('users', 'controls.user_id', '=', 'users.id')
                    ->select('controls.*', 'users.matricule')
                    ->where("controls.is_deleted", "=", 0)
                    ->orderBy('controls.created_at', 'desc')
                    ->take(20)
                    ->get();
                    $vehiclesInRule = Control::where('permit_conduire', 1)
                    ->where('date_validite_carte_grise', 1)
                    ->where('assurance', 1)
                    ->where('carte_visite_technique', 1)
                    ->where('tvm', 1)
                    ->count();

            // Compter le nombre de véhicules non en règle
            $vehiclesNotInRule = Control::where(function ($query) {
                                    $query->where('permit_conduire', 0)
                                        ->orWhere('date_validite_carte_grise', 0)
                                        ->orWhere('assurance', 0)
                                        ->orWhere('carte_visite_technique', 0)
                                        ->orWhere('tvm', 0)
                                        ;
                                })
                                ->count();

            // Calculer le total des véhicules
            $totalVehicles = Control::count();


        return view("pages.home",compact("controles","vehiclesInRule","vehiclesNotInRule","totalVehicles"));
    }
}
