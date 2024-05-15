<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Control extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'plaque',
        'nom_conducteur',
        'permit_conduire',
        'date_validite_carte_grise',
        'date_expiration',
        'carte_visite_technique',
        'assurance',
        'tvm',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
