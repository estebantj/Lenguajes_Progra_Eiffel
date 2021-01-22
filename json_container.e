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

	set_atributos(atributos:STRING)
		do
			nombre_atributos := atributos
		end

	set_datos(datos:STRING)
		do
			tipo_datos := datos
		end

	save_json (json: JSON_OBJECT)
		do
			lista_jsons.put_front (json)
		end

	print_jsons
		do
			print ("Imprimiendo todos los archivos json%N")
			across lista_jsons.new_cursor.reversed as json loop
				print (json.item.representation)
				Io.new_line
			end
		end

	create_string:STRING
		local
			representacion:STRING
		do
			representacion := "[%N"

			across lista_jsons.new_cursor.reversed as json loop
				representacion.append (json.item.representation)
				representacion.append ("%N")
			end

			representacion.append ("]")
			result := representacion
		end

	create_csv_string:STRING
		local
			representacion: STRING
			lista_atributos: LIST[STRING]
			item: STRING
			value: JSON_VALUE
		do
			lista_atributos := nombre_atributos.split (';')
			representacion := nombre_atributos.twin
			representacion.append ("%N")
			representacion.append (tipo_datos.twin)
			representacion.append ("%N")

			across lista_jsons.new_cursor.reversed as json loop
				across lista_atributos as atributo loop
					value := json.item.item (atributo.item)
					if value /= void then
						item := value.representation
						item.prune_all ('"')
						representacion.append (item+";")
					end
				end
				representacion.prune_all_trailing (';')
				representacion.append ("%N")
			end
			representacion.right_adjust
			result := representacion
		end

	project(pAtributos: LINKED_LIST[STRING]): JSON_CONTAINER
		local
			nuevo_contenedor: JSON_CONTAINER
			nuevo_json: JSON_OBJECT
		do
			create nuevo_contenedor.make
			across lista_jsons.new_cursor.reversed as json loop
				create nuevo_json.make_empty
				across pAtributos as atributo loop
					if json.item.has_key (atributo.item) then
						nuevo_json.put (json.item.item (atributo.item), atributo.item)
					end
				end
				if not nuevo_json.is_empty then
					nuevo_contenedor.save_json (nuevo_json)
				end
			end
			result := nuevo_contenedor
		end

	select_option(pAtributo_valor: LINKED_LIST[STRING]): JSON_CONTAINER
		local
			nuevo_contenedor: JSON_CONTAINER
			atributo: STRING
			valor: STRING
			valor_aux: STRING
			json_aux: JSON_VALUE
		do
			create nuevo_contenedor.make
			atributo := pAtributo_valor.first
			valor := pAtributo_valor.last
			across lista_jsons.new_cursor.reversed as json loop
				if json.item.has_key (atributo) then
					json_aux := json.item.item (atributo)
					if json_aux /= void then
						valor_aux := json_aux.representation
						valor_aux.replace_substring_all ("%"", "")
						if valor_aux.is_equal (valor) then
							nuevo_contenedor.save_json (json.item)
						end
					end
				end
			end
			result := nuevo_contenedor
		end
end
