({
    showToast: function (titleValue, messageValue, typeValue) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titleValue,
            "message": messageValue,
            "type": typeValue
        });
        toastEvent.fire();
    }
})
