#pragma once

#include "halley/core/game/scene_editor_interface.h"

namespace Halley {
	class EnumFieldFactory : public IComponentEditorFieldFactory
	{
	public:
		EnumFieldFactory(String name, std::vector<String> values);
		
		std::shared_ptr<IUIElement> createField(const ComponentEditorContext& context, const ComponentFieldParameters& pars) override;
		String getFieldType() override;

		template <typename T>
		static std::unique_ptr<EnumFieldFactory> makeEnumFactory(String name)
		{
			const auto& vals = EnumNames<T>()();
			return std::make_unique<EnumFieldFactory>(std::move(name), std::vector<String>(vals.begin(), vals.end()));
		}

	private:
		const String fieldName;
		std::vector<String> values;
	};
}
