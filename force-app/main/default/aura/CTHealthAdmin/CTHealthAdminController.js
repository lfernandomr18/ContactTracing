({
    handleActive: function (cmp, event, helper) {
        helper.loadTabs(cmp, event);
        //obtiene la tab seleccionada y dispara el evento
        var tab = event.getSource();
        const selectedTab=tab.get('v.id');
        helper.onTabSelected(selectedTab);
    }
})
