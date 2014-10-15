﻿using System.Collections.Generic;
using System.Linq;
using Orchard.Environment;
using Orchard.Layouts.Framework.Display;
using Orchard.Layouts.Framework.Elements;
using Orchard.Layouts.Framework.Harvesters;
using Orchard.Layouts.Services;

namespace Orchard.Layouts.Providers {
    public class TypedElementHarvester : IElementHarvester {
        private readonly Work<IElementManager> _elementManager;
        private readonly Work<IElementFactory> _factory;

        public TypedElementHarvester(Work<IElementManager> elementManager, Work<IElementFactory> factory) {
            _elementManager = elementManager;
            _factory = factory;
        }

        public IEnumerable<ElementDescriptor> HarvestElements(HarvestElementsContext context) {
            var drivers = _elementManager.Value.GetDrivers();
            var elementTypes = drivers.Select(x => x.GetType().BaseType.GenericTypeArguments[0]).Where(x => !x.IsAbstract && !x.IsInterface).ToArray();
            return elementTypes.Select(elementType => {
                var element = _factory.Value.Activate(elementType);
                return new ElementDescriptor(elementType, element.Type, element.DisplayText, element.Category) {
                    Displaying = displayContext => Displaying(displayContext, element),
                    IsSystemElement = element.IsSystemElement,
                    EnableEditorDialog = element.HasEditor
                };
            });
        }

        private void Displaying(ElementDisplayContext context, IElement element) {
            var drivers = _elementManager.Value.GetDrivers(element);

            foreach (var driver in drivers) {
                driver.Displaying(context);
            }
        }
    }
}