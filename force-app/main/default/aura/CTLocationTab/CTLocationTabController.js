({
    doInit: function (component, event, helper) {
        const columns = [
            { label: "PersonName", fieldName: "PersonName", type: "text" },
            { label: "PersonHealthStatus", fieldName: "PersonHealthStatus", type: "text" },
            { label: "VisitDate", fieldName: "VisitDate", type: "date" }
        ];
        component.set("v.columns", columns);
    },
    locationSearchHandler: function (component, event, helper) {
        helper.fetchLocationInformation(component);
    },
})
