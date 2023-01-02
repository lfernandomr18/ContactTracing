({
    loadTabs: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            //cambia el nombre del headerTitle de acuerdo a la tab seleccionada
            case 'person_view' :
                cmp.set("v.pageHeaderTitle","Person View");
                break;
            case 'location_view' :
                cmp.set("v.pageHeaderTitle","Location View");
                break;
        }
    },
    onTabSelected: function (selectedTab) {
        const appevent = $A.get("e.c:tabSelectedEvent");
        appevent.setParams({ selectedTab: selectedTab });
        appevent.fire();
    }

})
