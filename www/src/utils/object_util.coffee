class theoricus.utils.ObjectUtil

	@find:( src, search, strong_typing = false )->

		for k, v of search

			if v instanceof Object
				return ObjectUtil.find src[k], v

			else if strong_typing
				return src if src[k] == v

			else
				return src if "#{src[k]}" is "#{v}"
		return null