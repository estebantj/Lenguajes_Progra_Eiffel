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
			print ("Atributos: "+nombre_atributos+"%N")
			print ("Tipo datos: "+tipo_datos+"%N")
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

	index_of(lista:LINKED_LIST[ANY];item:ANY):INTEGER
		local
			index: INTEGER
			index_aux: INTEGER
		do
			index := 0
			from
				index_aux := 1
			until
				index_aux > lista.count
			loop
				if lista[index_aux].is_equal (item) then
					index := index_aux
					index_aux := lista.count
				end
				index_aux := index_aux + 1
			end
			result := index
		end

	project(pAtributos: LINKED_LIST[STRING]): JSON_CONTAINER
		local
			nuevo_contenedor: JSON_CONTAINER
			nuevo_json: JSON_OBJECT
			lista_atributos: LINKED_LIST[STRING]
			lista_tipo_datos: LINKED_LIST[STRING]
			index: INTEGER
			nuevos_atributos: STRING
			nuevos_tipos: STRING
		do
			create nuevo_contenedor.make
			create lista_atributos.make_from_iterable (nombre_atributos.split (';'))
			create lista_tipo_datos.make_from_iterable (tipo_datos.split (';'))
			nuevos_atributos := ""
			nuevos_tipos := ""
			--print("-"+lista_atributos[2]+"-"+"-"+pAtributos[2]+"-%N")
			--if lista_atributos[2].is_equal (pAtributos[2]) then
			--	print("SON IGUALES%N")
			--else
			--	print("NO SON IGUALES%N")
			--end
			across pAtributos as atributo loop
				index := index_of(lista_atributos,atributo.item)
				if index /= 0 then
					nuevos_atributos.append (atributo.item+";")
					nuevos_tipos.append (lista_tipo_datos[index]+";")
				else
					print("Atributo "+atributo.item+" no encontrado%N")
				end
			end

			nuevos_atributos.prune_all_trailing (';')
			nuevos_tipos.prune_all_trailing (';')
			nuevo_contenedor.set_atributos (nuevos_atributos)
			nuevo_contenedor.set_datos (nuevos_tipos)

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

	select_option(atributo: STRING; valor:STRING): JSON_CONTAINER
		local
			nuevo_contenedor: JSON_CONTAINER
			nuevo_json: JSON_OBJECT
			valor_aux: STRING
			json_aux: JSON_VALUE
		do
			create nuevo_contenedor.make
			nuevo_contenedor.set_atributos (nombre_atributos)
			nuevo_contenedor.set_datos (tipo_datos)
			create nuevo_json.make_empty
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
