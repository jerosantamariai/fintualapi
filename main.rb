require 'rubygems'              #sudo gem install rubygems
require 'httparty'              #sudo gem install httparty
require 'pry'                   #sudo gem install pry
require 'json'                  #sudo gem install json

# ************ INPUTS ************

puts "Cuánto dinero invertiste? "                                                           #INGRESAMOS MONTO INVERTIDO
$invest_cash = gets.to_f
puts "Ingresa una fecha con formato YYYY-MM-DD "                                            #INGRESAMOS FECHA DE INVERSIÓN
$fecha_inicio = gets
puts "La fecha ingresada fue " + $fecha_inicio
$now = "2021-02-18"                                                                         #OBLIGO LA ULTIMA FECHA DISPONIBLE EN LA API, NO PUDE HACERLA DINAMICA POR TIEMPO
puts "Cuál fue tu posicionamiento en Risky Norris? (Usar decimales con punto) "             #INGRESAMOS EL FACTOR DE INVERSIÓN EN RISKY NORRIS
$invest_riskynorris = gets.to_f 
puts "Cuál fue tu posicionamiento en Moderate Pitt? (Usar decimales con punto) "            #INGRESAMOS EL FACTOR DE INVERSIÓN EN MODERATE PITT
$invest_moderatepitt = gets.to_f
puts "Cuál fue tu posicionamiento en Conservative Clooney? (Usar decimales con punto) "     #INGRESAMOS EL FACTOR DE INVERSIÓN EN CONSERVATIVE CLOONEY
$invest_conservativeclooney = gets.to_f

# ************ RISKY NORRIS ************

response_riskynorris_0 = HTTParty.get("https://fintual.cl/api/real_assets/186/days?date=#{$fecha_inicio}")  #OBTENEMOS LA RESPUESTA DE LA API PARA EL DIA DE INVERSIÓN
parsed_riskynorris_0 = JSON.parse(response_riskynorris_0&.body || "{}")                                     #ANALIZAMOS LA RESPUESTA DE LA API
array_of_datas_0 = parsed_riskynorris_0["data"]                                                             #SOLICITAMOS INFORMACIÓN DENTRO DE LA API QUE SE ENCUENTRA DENTRO DEL ARRAY 'DATA'

array_of_datas_0.each do |data|
    $dia0 = data["attributes"]["date"]                                                                      #OBTENEMOS EL DÍA EN QUE SE INVIRTIO PARA CORROBORAR QUE LA INFORMACIÓN SEA CORRECTA
    # puts $dia0
    $precio0 = data["attributes"]["price"]                                                                  #OBTENEMOS EL VALOR DE RISKY NORRIS PARA EL DÍA DETERMINADO
    # puts $precio0
end

response_riskynorris_1 = HTTParty.get("https://fintual.cl/api/real_assets/186/days?date=#{$now}")           #OBTENEMOS LA RESPUESTA DE LA API PARA EL ÚLTIMO DÍA DISPONIBLE EN LA API
parsed_riskynorris_1 = JSON.parse(response_riskynorris_1&.body || "{}")                                     #ANALIZAMOS LA RESPUESTA DE LA API
array_of_datas_1 = parsed_riskynorris_1["data"]                                                             #SOLICITAMOS INFORMACIÓN DENTRO DE LA API QUE SE ENCUENTRA DENTRO DEL ARRAY 'DATA'

array_of_datas_1.each do |data|
    $dia1 = data["attributes"]["date"]                                                                      #OBTENEMOS EL ÚLTIMO DÍA CON INFORMACIÓN DISPONIBLE EN LA API
    # puts $dia1
    $precio1 = data["attributes"]["price"]                                                                  #OBTENEMOS EL VALOR DE RISKY NORRIS PARA EL ÚLTIMO DÍA CON INFORMACIÓN DISPONIBLE EN LA API
    # puts $precio1
end

riskynorris_rate = ($precio1 - $precio0) / $precio0                                                         #CON TODA LA INFORMACIÓN OBTENIDA EN LAS LINEAS DE CODIGO 24-44, OBTENEMOS POR MATEMÁTICAS SIMPLES EL VALOR DEL RETORNO ENTRE LA FECHA ENTREGADA Y LA FECHA OBLIGADA
# puts riskynorris_rate
add_riskynorris = riskynorris_rate * $invest_riskynorris                                                    #CON LA INFORMACIÓN INMEDIATAMENTE ANTERIOR, CALCULAMOS LA PONDERACIÓN DEL RETORNO BAJO DEPENDENCIA DE PARTICIPACIÓN DE LA INVERSIÓN. ESTA INFORMACIÓN SERVIRÁ MÁS ADELANTE
# puts add_riskynorris

# ************ MODERATE PITT ************

response_moderatepitt_2 = HTTParty.get("https://fintual.cl/api/real_assets/187/days?date=#{$fecha_inicio}") #REALIZANDO LOS MISMOS PASOS ANTERIORES, TOMAMOS LA INFORMACIÓN DE LA API PARA MODERATE PITT
parsed_moderatepitt_2 = JSON.parse(response_moderatepitt_2&.body || "{}")                                   #LA ANALIZAMOS
array_of_datas_2 = parsed_moderatepitt_2["data"]                                                            #INGRESAMOS AL ARRAY 'DATA'

array_of_datas_2.each do |data|
    $dia2 = data["attributes"]["date"]                                                                      #OBTENEMOS LA FECHA PARA SABER SI CORRESPONDE LA INFORMACIÓN
    # puts $dia2
    $precio2 = data["attributes"]["price"]                                                                  #OBTENEMOS EL PRECIO PARA EL PRIMER DÍA DE LA INVERSIÓN
    # puts $precio2
end

response_moderatepitt_3 = HTTParty.get("https://fintual.cl/api/real_assets/187/days?date=#{$now}")          #AHORA TRABAJAMOS CON LA INFORMACIÓN DEL DÍA OBLIGADO PARA MODERATE PITT
parsed_moderatepitt_3 = JSON.parse(response_moderatepitt_3&.body || "{}")
array_of_datas_3 = parsed_moderatepitt_3["data"]

array_of_datas_3.each do |data|
    $dia3 = data["attributes"]["date"]
    # puts $dia3
    $precio3 = data["attributes"]["price"]                                                                  #OBTENEMOS EL PRECIO DE MODERATE PITT PARA EL DÍA OBLIGADO
    # puts $precio3
end

moderatepitt_rate = ($precio3 - $precio2) / $precio2                                                        #OBTENEMOS EL RETORNO DE MODERATE PITT ENTRE LOS DÍAS DE COMIENZO DE LA INVERSION CON EL DÍA OBLIGADO
# puts moderatepitt_rate
add_moderatepitt = moderatepitt_rate * $invest_moderatepitt                                                 #OBTENEMOS EL VALOR PODERADO DE MODERATE PITT ENTRE LAS FECHAS BAJO LA PARTICIPACIÓN DETERMINADA EN EL ACTIVO. ESTE DATO SE USARÁ DESPUES
# puts add_moderatepitt

# ************ CONSERVATIVE CLOONEY ************

response_conservativeclooney_4 = HTTParty.get("https://fintual.cl/api/real_assets/188/days?date=#{$fecha_inicio}")      #AHORA NUEVAMENTE, OBTENEMOS LA INFORMACIÓN PERO PARA EL ACTIVO CONSERVATIVE CLOONEY
parsed_conservativeclooney_4 = JSON.parse(response_conservativeclooney_4&.body || "{}")
array_of_datas_4 = parsed_conservativeclooney_4["data"]

array_of_datas_4.each do |data|
    $dia4 = data["attributes"]["date"]
    # puts $dia4
    $precio4 = data["attributes"]["price"]                                                                              #OBTENEMOS EL PRECIO DEL PRIMER DIA DE INVERSIÓN
    # puts $precio4
end

response_conservativeclooney_5 = HTTParty.get("https://fintual.cl/api/real_assets/188/days?date=#{$now}")               #BUSCAMOS INFORMACIÓN PARA CONSERVATIVE CLOONEY PARA LA ÚLTIMA FECHA DISPONIBLE EN LA API
parsed_conservativeclooney_5 = JSON.parse(response_conservativeclooney_5&.body || "{}")
array_of_datas_5 = parsed_conservativeclooney_5["data"]

array_of_datas_5.each do |data|
    $dia5 = data["attributes"]["date"]
    # puts $dia5
    $precio5 = data["attributes"]["price"]                                                                              #OBTENEMOS EL PRECIO PARA CONSERVATIVE CLOONEY PARA LA ULTIMA FECHA DISPONIBLE
    # puts $precio5
end

conservativeclooney_rate = ($precio5 - $precio4) / $precio4                                                             #OBTENEOS EL RETORNO PARA CONSERVATIVE CLOONEY DENTRO DE LOS PLAZOS DADOS
# puts conservativeclooney_rate
add_conservativeclooney = conservativeclooney_rate * $invest_conservativeclooney                                        #OBTENEMOS EL VALOR PONDERADO DE CONSERVATIVE CLOONEY DADA SU PARTICIPACIÓN EN LA CARTERA DE INVERSIÓN
# puts add_conservativeclooney

# ************ RESULTADOS ************

total_rate = add_riskynorris + add_moderatepitt + add_conservativeclooney                                               #SUMAMOS LA INFORMACIÓN DE LOS VALORES PONDERADOS PARA LOS 3 ACTIVOS CONSIDERADOS OBTENIENDO DE ESTA FORMA EL RETORNO TOTAL PARA EL PORTAFOLIO DEL CLIENTE DADA LA INFORMACIÓN ENTREGADA
# puts total_rate
today_value = (1 + total_rate) * $invest_cash                                                                           #OBTENEMOS EL VALOR ACTUAL DE LA INVERSIÓN DESDE QUE SE COMPRÓ EL PORTAFOLIO HASTA EL ÚLTIMO DÍA CON INFORMACIÓN DISPONIBLE EN LA API
# puts today_value
earn_loss = today_value - $invest_cash                                                                                  #OBTENEMOS EL VALOR DE LAS GANANCIAS O PERDIDAS DE LA INVERSIÓN
# puts earn_loss

# ************ RESPUESTA FINAL ************

queryResponse = "Al haber invertido $#{$invest_cash} el día #{$fecha_inicio}, con un #{$invest_riskynorris*100}% en Risky Norris, un #{$invest_moderatepitt*100}% en Moderate Pitt y un #{$invest_conservativeclooney*100}% en Conservative Clooney, al día #{$now}, tu inversión rentó un #{total_rate*100}%, quedando un valor actual de tu inversión en #{today_value} habiendo ganado/perdido #{earn_loss} durante dicho periodo."
puts queryResponse

