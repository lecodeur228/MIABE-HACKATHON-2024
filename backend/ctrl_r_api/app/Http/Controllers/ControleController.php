<?php

namespace App\Http\Controllers;

use App\Models\Control;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class ControleController extends Controller
{
    
    public function addControl(Request $request)
    {
        $user = Auth::user();
    
        try {
            // Valider les données de la requête
            $validatedData = $request->validate([
                'plaque' => 'required|string',
                'nom_conducteur' => 'required|string',
                'permit_conduire' => 'integer',
                'date_validite_carte_grise' => 'integer',
                'date_expiration' => 'date|nullable',
                'carte_visite_technique' => 'integer',
                'assurance' => 'integer',
                'tvm' => 'integer',
                'latitude' => 'string',
                'longitude' => 'string',
            ]);
            
            // Vérifier si un contrôle a déjà été effectué pour ce véhicule dans la même zone et à la même date
            $existingControl = Control::where('plaque', $validatedData['plaque'])
                ->where('latitude', $validatedData['latitude'])
                ->where('longitude', $validatedData['longitude'])
                ->whereDate('created_at', '=', now()->toDateString())
                ->latest()
                ->first();
    
            if ($existingControl) {
                // Un contrôle correspondant a déjà été effectué
                return response()->json([
                    'message' => 'Ce véhicule a déjà été contrôlé dans la même zone à la même date',
                    'status' => 'ECHEC'
                ], 200);
            }
    
            // Aucun contrôle correspondant trouvé, donc ajoutez le nouveau contrôle
            $control = new Control();
            $control->user_id = $user->id;
            $control->plaque = $validatedData['plaque'];
            $control->nom_conducteur = $validatedData['nom_conducteur'];
            $control->permit_conduire = $validatedData['permit_conduire'] ?? false;
            $control->date_validite_carte_grise = $validatedData['date_validite_carte_grise'] ?? false;
            $control->date_expiration = $validatedData['date_expiration'];
            $control->carte_visite_technique = $validatedData['carte_visite_technique'] ?? false;
            $control->assurance = $validatedData['assurance'] ?? false;
            $control->tvm = $validatedData['tvm'] ?? false;
            $control->latitude = $validatedData['latitude'];
            $control->longitude = $validatedData['longitude'];
            $control->save();
    
            return response()->json(['message' => 'Contrôle ajouté avec succès','status' => 'SUCCES'], 200);
        } catch (ValidationException $e) {
            // Renvoyer les erreurs de validation
            return response()->json([
                'errors' => $e->errors(),
                'status' => 'ECHEC'
            ], 422);
        } catch (\Exception $e) {
            // Renvoyer toute autre erreur
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 'ECHEC'
            ], 500);
        }
    }
    public function getControlsWithUser()
    {
        try {
            // Récupérer les contrôles avec le nom et le matricule des utilisateurs qui les ont ajoutés
            $controls = Control::join('users', 'controls.user_id', '=', 'users.id')
                                ->select('controls.*', 'users.matricule')
                                ->orderBy('controls.created_at', 'desc')
                                ->get();

            return response()->json(['controls' => $controls,'status' => 'SUCCES']);
        } catch (\Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ], 500);
        }
    }

    public function searchControlByPlaque(Request $request)
    {
        $validatedData = $request->validate([
            'plaque' => 'required|string',
        ], [
            'plaque.required' => 'Le numéro de plaque est requis.',
        ]);

        try {
            // Rechercher un contrôle en fonction de la plaque
            $control = Control::where('plaque', $validatedData['plaque'])->first();

            if ($control) {
                return response()->json(['control' => $control,'status' => 'SUCCES']);
            } else {
                return response()->json(['message' => 'Aucun contrôle trouvé pour cette plaque.','status' => 'NOT-FOUND']);
            }
        } catch (\Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ], 500);
        }
    }

    public function getFilteredControls(Request $request)
{
    // Valider les données entrées pour les critères de filtre
    $validatedData = $request->validate([
        'permit_ok' => 'integer',
        'carte_grise_ok' => 'integer',
        'assurance_ok' => 'integer',
        // Ajoutez d'autres critères de filtre si nécessaire
    ]);

    try {
        // Commencer avec tous les contrôles
        $query = Control::query();

        // Appliquer les filtres selon les critères spécifiés
        if (isset($validatedData['permit_ok'])) {
            $query->where('permit_conduire', $validatedData['permit_ok']);
        }

        if (isset($validatedData['carte_grise_ok'])) {
            $query->where('date_validite_carte_grise', $validatedData['carte_grise_ok']);
        }

        if (isset($validatedData['assurance_ok'])) {
            $query->where('assurance', $validatedData['assurance_ok']);
        }

        // Ajoutez d'autres filtres si nécessaire

        // Récupérer les contrôles filtrés
        $filteredControls = $query->orderBy('created_at', 'desc')->get();

        return response()->json(['controls' => $filteredControls,'status' => 'SUCCES']);
    } catch (\Exception $e) {
        return response()->json([
            'erreur' => $e->getMessage(),
            'status' => 'ECHEC'
        ], 500);
    }
}

public function getVehicleStats()
{
    try {
        // Compter le nombre de véhicules en règle
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

        return response()->json([
            'vehicles_in_rule' => $vehiclesInRule,
            'vehicles_not_in_rule' => $vehiclesNotInRule,
            'total_vehicles' => $totalVehicles,
            'status' => 'SUCCESS'
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'error' => $e->getMessage(),
            'status' => 'ECHEC'
        ], 500);
    }
}

public function fakeDeleteControle($id){
    if (!Auth::user()->isAdmin()) {
        return response()->json(['message' => 'Seuls les administrateurs peuvent supprimser un contrôle.'], 403);
    }
    $control = Control::find($id);
    $control->is_deleted = 1;
    $control->deleter_matricule = Auth::user()->matricule;
    $control->save();
}

}
