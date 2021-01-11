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
	    	i: INTEGER
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
					linea := archivo.last_string.twin
					print("Primera linea: "+linea+"%N")
					from
						i := 0
					until
						i >= 1
					loop
						archivo.read_line
						if not archivo.last_string.is_empty then
							linea := archivo.last_string.twin
							print(linea+"%N")
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
