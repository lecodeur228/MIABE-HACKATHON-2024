<?php

use App\Models\User;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('controls', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(User::class);
            $table->string('plaque');
            $table->string('nom_conducteur');
            $table->integer('permit_conduire')->default(0);
            $table->integer('date_validite_carte_grise')->default(0);
            $table->date('date_expiration')->nullable();
            $table->integer('carte_visite_technique')->default(0);
            $table->integer('assurance')->default(0);
            $table->integer('tvm')->default(0);
            $table->string("longitude");
            $table->string("latitude");
            $table->integer("is_deleted")->default(0);
            $table->string("deleter_matricule")->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('controls');
    }
};
