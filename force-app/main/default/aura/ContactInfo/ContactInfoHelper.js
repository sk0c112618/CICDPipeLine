({
	doInitHelper : function(component) {
		alert(component.get('v.firstName'))	
        component.set('v.firstName','Harsh');
        alert(component.get('v.firstName'))	
	}
})