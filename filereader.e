note
	description: "Summary description for {FILEREADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FILEREADER

feature
	load_csv_as_json (nombre_archivo: STRING)
	    local
	    	archivo: PLAIN_TEXT_FILE
	    	linea: STRING
	    	linea_separada: LIST[STRING]
	    	i: INTEGER
	    	j: INTEGER
	    	json: JSON_OBJECT
	    	nombre_atributos: LIST[STRING]
	    	tipo_datos: LIST[STRING]
	    do
	    	create archivo.make (nombre_archivo)
	        if not archivo.exists then
    			print ("Archivo no encontrado%N")
    		else
				if not archivo.is_readable then
					print("No se puede leer el archivo%N")
				else
					archivo.open_read
					archivo.read_line
					-- Se guarda el nombre de cada atributo para su uso posterior
					linea := archivo.last_string.twin
					print("Atributos: "+linea+"%N")
					nombre_atributos := linea.split (';')

					archivo.read_line
					-- Se guarda el tipo de datos de cada atributo
					linea := archivo.last_string.twin
					print("Tipo de datos : "+linea+"%N")
					tipo_datos := linea.split (';')

					-- Este ciclo se repite hasta que se no se puedan leer mas lineas del archvo
					from
						i := 0
					until
						i >= 1
					loop
						archivo.read_line
						if not archivo.last_string.is_empty then
							linea := archivo.last_string.twin
							linea_separada := linea.split (';')
							from
								j:=1
							until
								j:=linea_separada.count
							loop
								
								j := j+1
							end

							i := i - 1
						else
							i := 1
						end

					end
					archivo.close
				end
    		end
	    end
end
