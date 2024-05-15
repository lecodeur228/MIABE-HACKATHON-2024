@extends("index")
@section("content")

    <div class="container-fluid">
      <!--  Row 1 -->
      <div class="row">
        
          <div class="row">
            <div class="col-lg-4">
                <!-- Yearly Breakup -->
                <div class="card overflow-hidden">
                  <div class="card-body p-4">
                    <h5 class="card-title mb-9 fw-semibold">Nombre totals de contrôls</h5>
                    <div class="row align-items-center">
                      <div class="col-8">
                        <h4 class="fw-semibold mb-3 text-center">{{ $totalVehicles }}</h4>
                    
                        
                      </div>
                      
                    </div>
                  </div>
                </div>
            </div>
            <div class="col-lg-4">
              <!-- Yearly Breakup -->
              <div class="card overflow-hidden">
                <div class="card-body p-4">
                  <h5 class="card-title mb-9 fw-semibold">Nombres de contrôls en regle :</h5>
                  <div class="row align-items-center">
                    <div class="col-8">
                      <h4 class="fw-semibold mb-3">{{ $vehiclesInRule }}</h4>
                     
                      
                    </div>
                    
                  </div>
                </div>
              </div>
            </div>
           
              <div class="col-lg-4">
                <div class="card overflow-hidden">
                  <div class="card-body p-4">
                    <h5 class="card-title mb-9 fw-semibold">Nombres de contrôls en infraction :</h5>
                    <div class="row align-items-center">
                      <div class="col-8">
                        <h4 class="fw-semibold mb-3">{{ $vehiclesNotInRule }}</h4>
                       
                        
                      </div>
                      
                    </div>
                  </div>
                </div>
              </div>
           
          
            </div>
      
        <div class="col-lg-12 d-flex align-items-stretch">
          <div class="card w-100">
            <div class="card-body p-4">
              <h5 class="card-title fw-semibold mb-4">Recent contrôles</h5>
              <div class="table-responsive">
                <table class="table text-nowrap mb-0 align-middle">
                  <thead class="text-dark fs-4">
                    <tr>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Date</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Plaque</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Conducteur</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Permit</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">carte gris</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Visite technique</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Assurance</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">TVM</h6>
                      </th>
                      <th class="border-bottom-0">
                        <h6 class="fw-semibold mb-0">Localisation</h6>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    @forelse ($controles as $controle) 
                    <tr>
                       <td class="border-bottom-0"><h6 class="fw-semibold mb-0">1</h6></td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-1">{{ $controle->plaque }}</h6>                      
                       </td>
                       <td class="border-bottom-0">
                         <p class="mb-0 fw-normal">{{ $controle->nom_conducteur }}</p>
                       </td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-0 fs-5 text-center">
                               @if($controle->permit_conduire == 1)
                                   <i class="fa-solid fa-check" style="color: green"></i>
                               @else
                                   <i class="fa-solid fa-xmark" style="color: red"></i>
                               @endif
                           </h6>                        </td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-0 fs-5 text-center">
                               @if($controle->date_valide_carte_gris == 1)
                                   <i class="fa-solid fa-check" style="color: green"></i>
                               @else
                                   <i class="fa-solid fa-xmark" style="color: red"></i>
                               @endif
                           </h6>                        </td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-0 fs-5 text-center">
                               @if($controle->visite_technique == 1)
                                   <i class="fa-solid fa-check" style="color: green"></i>
                               @else
                                   <i class="fa-solid fa-xmark" style="color: red"></i>
                               @endif
                           </h6>                        </td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-0 fs-5 text-center">
                               @if($controle->assurance == 1)
                                   <i class="fa-solid fa-check" style="color: green"></i>
                               @else
                                   <i class="fa-solid fa-xmark" style="color: red"></i>
                               @endif
                           </h6>                        </td>
                       <td class="border-bottom-0">
                           <h6 class="fw-semibold mb-0 fs-5 text-center">
                               @if($controle->tvm == 1)
                                   <i class="fa-solid fa-check" style="color: green"></i>
                               @else
                                   <i class="fa-solid fa-xmark" style="color: red"></i>
                               @endif
                           </h6>                        </td>
                       <td class="border-bottom-0">
                           <a href="https://www.google.com/maps?q={{ $controle->latitude }},{{ $controle->longitude }}&ll={{ $controle->latitude }},{{ $controle->longitude }}&z=15" target="_blank">
                               <h6 class="fw-semibold mb-0 fs-5 text-center"><i class="fa-solid fa-location-dot"></i></h6>
                           </a>
                           
                       </td>
                     </tr> 
                    @empty
                        <div class="alert alert-warning">
                            Aucun résultat trouvé pour votre recherche
                        </div>
                    @endforelse
                                          
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
@endsection