do $$
declare
    v_data_source_name varchar(255) = 'Columbia University Libraries Digital Collections';
    v_data_source_id integer;
begin
    select
        id
    into
        v_data_source_id
    from datasources
    where
        name = v_data_source_name
    ;
    raise notice 'The script will be purging data source # % ("%")',
        v_data_source_id,
        v_data_source_name
    ;

    /*
     * 1. Delete all the hyperlinks related to the specific data source.
     * It will force CM to use newly imported links.
     */
    raise notice '1. Deleting all the hyperlinks for data source # % ("%") ...',
        v_data_source_id,
        v_data_source_name
    ;
    delete
    from
        hyperlinks as h
    using
        resources as r
    where
        h.resource_id = r.id
        and r.data_source_id = v_data_source_id
    ;
    raise notice '1. Hyperlinks for data source # % ("%") have been successfully deleted',
        v_data_source_id,
        v_data_source_name
    ;

    /*
     * 2.Swipe out fulfillment info because the URL of the acquisition link has
     * changed and it has to be updated.
     */
    raise notice '2. Resetting all loan fulfillment info for data source # % ("%") ...',
        v_data_source_id,
        v_data_source_name
    ;
    update loans as l
    set
        fulfillment_id = null
    from licensepools as lp
    where
        l.license_pool_id = lp.id
        and lp.data_source_id = v_data_source_id
    ;
    raise notice '2. Loan fulfillment info for data source # % ("%") has been successfully reset',
        v_data_source_id,
        v_data_source_name
    ;

    /*
     * 3. Delete fulfillment objects because the URL of the acquisition link has
     * changed and they have to be updated.
     */
    raise notice '3. Deleting fulfillment objects for data source # % ("%") ...',
        v_data_source_id,
        v_data_source_name
    ;
    delete from licensepooldeliveries
    where
      data_source_id = v_data_source_id
    ;
    raise notice '3. Fulfillment info for data source # % ("%") has been successfully deleted',
        v_data_source_id,
        v_data_source_name
    ;

    /*
     * Reset open_access_download_url because the URL of the acquisition link has changed
     * and it has to be updated.
     */
    raise notice '4. Resetting open_access_download_url for data source # % ("%") ...',
        v_data_source_id,
        v_data_source_name
    ;
    update licensepools
    set
      open_access_download_url = null
    where
      data_source_id = v_data_source_id
    ;
    raise notice '4. open_access_download_url for data source # % ("%") has been successfully reset',
        v_data_source_id,
        v_data_source_name
    ;

    /*
     * Reset cover URLs to force them to be updated during the next import.
     */
    raise notice '5. Resetting cached cover links for data source # % ("%") ...',
        v_data_source_id,
        v_data_source_name
    ;
    update editions
    set
        cover_full_url = null,
        cover_thumbnail_url = null
    where
      data_source_id = v_data_source_id
    ;
    raise notice '5. Cached cover links for data source # % ("%") have been successfully reset',
        v_data_source_id,
        v_data_source_name
    ;
end $$;
