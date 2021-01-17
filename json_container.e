note
	description: "Summary description for {JSON_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_CONTAINER

create
	make

feature {NONE}
	lista_jsons: LINKED_LIST [JSON_OBJECT]
	nombre_atributos: STRING
	tipo_datos: STRING

feature
	make
		do
			create lista_jsons.make
			nombre_atributos := ""
			tipo_datos := ""
		end

	save_json (json: JSON_OBJECT)
		do
			lista_jsons.put_front (json)
		end

	print_jsons
		do
			print ("Imprimiendo todos los archivos jsos%N")
			across lista_jsons as json loop
				print (json.item.representation)
				Io.new_line
			end
		end

	create_string:STRING
		local
			representacion:STRING
		do
			representacion := "[%N"

			across lista_jsons as json loop
				representacion.append (json.item.representation)
				representacion.append ("%N")
			end

			representacion.append ("]")
			result := representacion
		end

	set_atributos(atributos:STRING)
		do
			nombre_atributos := atributos
		end

	set_datos(datos:STRING)
		do
			tipo_datos := datos
		end
end
