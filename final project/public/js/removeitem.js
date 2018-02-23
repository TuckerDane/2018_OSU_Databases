function removeitem(id){
    $.ajax({
        url: '/pack/contents' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};