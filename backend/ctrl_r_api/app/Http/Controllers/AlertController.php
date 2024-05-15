<?php

namespace App\Http\Controllers;

use App\Models\Alert;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AlertController extends Controller
{
    public function addAlert(Request $request)
    {
        // Vérifier si l'utilisateur est un administrateur
        if (!Auth::user()->isAdmin()) {
            return response()->json(['message' => 'Seuls les administrateurs peuvent ajouter des alertes.'], 403);
        }

        $validatedData = $request->validate([
            
            'plaque' => 'required|string',
            'motif' => 'required|string',
            'description' => 'required|string',
        ]);

        try {
            // Créer une nouvelle instance d'alerte
            $alert = new Alert();
            $alert->user_id = Auth::user()->id;
            $alert->plaque = $validatedData['plaque'];
            $alert->motif = $validatedData['motif'];
            $alert->description = $validatedData['description'];
            $alert->save();

            return response()->json(['message' => 'Alerte ajoutée avec succès','status' => 'SUCCES']);
        } catch (\Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ], 500);
        }
    }
    public function getAlerts()
    {
        try {
            // Récupérer les alertes dans l'ordre chronologique avec les matricules des utilisateurs
            $alerts = Alert::with('user')->orderBy('created_at', 'desc')->get();
            
            return response()->json(['alerts' => $alerts,'status' => 'SUCCES']);
        } catch (\Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ]);
        }
    }
    
    public function deleteAlert(Request $request, $id)
    {
        try {
            // Récupérer l'alerte à supprimer
            $alert = Alert::findOrFail($id);

            // Vérifier si l'utilisateur authentifié est l'auteur de l'alerte
            if ($alert->user_id !== Auth::user()->id) {
                return response()->json(['message' => 'Vous n\'êtes pas autorisé à supprimer cette alerte.','status'=>'ECHEC'], 200);
            }

            // Supprimer l'alerte
            $alert->delete();

            return response()->json(['message' => 'Alerte supprimée avec succès', 'status' => 'SUCCES']);
        } catch (\Exception $e) {
            return response()->json(['erreur' => $e->getMessage(), 'status' => 'ECHEC']);
        }
    }
}
