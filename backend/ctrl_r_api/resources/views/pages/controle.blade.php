@extends("index")
@section("content")
<div class="container-fluid">
    <div class="container-fluid">
        <div class="d-flex">
           <form action="{{route("controle_page")}}" class="d-flex" method="get">
            <input type="search" class="form-control" name="plaque" placeholder="Numéro de la plaque...">
            <button type="submit" class="btn btn-primary mx-2" >Rechercher</button></form>
        </div>
        <div class="col-lg-12 d-flex mt-3 align-items-stretch">
            <div class="card w-100 ">
              <div class="card-body p-4">
                <h5 class="card-title fw-semibold mb-4">List des contrôles</h5>
                <div class="table-responsive">
                  <table class="table text-nowrap mb-0 align-middle">
                    <thead class="text-dark fs-4">
                      <tr>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Date</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Agent</h6>
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
                        <td class="border-bottom-0"><h6 class="fw-semibold mb-0">{{$controle->created_at->format("d/m/y") }}</h6><p class="fw-semibold mb-0">{{$controle->created_at->format("h:m") }}</p></td>
                        <td class="border-bottom-0">
                            <h6 class="fw-semibold mb-1">{{ $controle->user->matricule }}</h6>                      
                        </td>
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
    </div>
</div>
@endsection