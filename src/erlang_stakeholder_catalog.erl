-module(erlang_stakeholder_catalog).
-export([
    all_generator_families/0,
    classic_six/0,
    modern_core/0,
    later_fallback/0,
    family_label/1,
    normalize_family/1,
    family_group_label/1,
    renderer_key/1,
    tranche_for/1,
    context_for/1,
    list_values/0
]).

all_generator_families() ->
    classic_six() ++ modern_core() ++ later_fallback().

classic_six() ->
    [code_analyzer, data_processing, jargon, metrics, network_activity, system_monitoring].

modern_core() ->
    [agent_workflows, platform_engineering, observability_ai_runtime, delivery_preview_ops, supply_chain_security].

later_fallback() ->
    [
        ai_inference_ops,
        evaluation_and_guardrails,
        knowledge_retrieval,
        edge_client_runtime,
        identity_and_trust,
        aibom_provenance,
        agent_boundary_security,
        embedded_agentic_pipeline,
        data_governance_compliance,
        finops_capacity,
        blockchain_protocol_ops,
        cross_chain_interop,
        proof_and_sequencer_ops,
        hybrid_runtime_ops,
        capacity_cost_controller,
        batch_execution_tuner,
        compiler_maintainer,
        interop_adapter_engineer,
        preflight_capacity_planner,
        simulator_performance_engineer,
        fhir_profile_generator,
        smart_launch_oauth,
        bulk_fhir_population_ops,
        hl7v2_feed_ops,
        clinical_workflow_events,
        dicomweb_imaging_ops,
        openehr_semantic_record_ops,
        device_telemetry_clinical,
        emr_vendor_adapter,
        ocpp_chargepoint_ops,
        ocpi_roaming_ops,
        mcp_a2a_ops,
        streaming_bus_ops,
        service_mesh_rpc_ops
    ].

family_label(Family) ->
    string:replace(atom_to_list(Family), "_", "-", all).

normalize_family(Value) when is_atom(Value) ->
    case lists:member(Value, all_generator_families()) of
        true -> Value;
        false -> erlang:error({invalid_family, Value})
    end;
normalize_family(Value) when is_binary(Value) ->
    normalize_family(binary_to_list(Value));
normalize_family(Value) when is_list(Value) ->
    Candidate = string:lowercase(Value),
    case [Family || Family <- all_generator_families(), Candidate =:= family_label(Family) orelse Candidate =:= atom_to_list(Family)] of
        [Family] -> Family;
        _ -> erlang:error({invalid_family, Value})
    end.

family_group_label(Family) ->
    case lists:member(Family, classic_six()) of
        true -> <<"classic-six">>;
        false ->
            case lists:member(Family, modern_core()) of
                true -> <<"modern-core">>;
                false -> <<"grouped-fallback">>
            end
    end.

renderer_key(Family) ->
    case lists:member(Family, classic_six()) of
        true -> list_to_binary("classic-six." ++ atom_to_list(Family));
        false ->
            case lists:member(Family, modern_core()) of
                true -> list_to_binary("modern-core." ++ atom_to_list(Family));
                false -> fallback_renderer_key(Family)
            end
    end.

tranche_for(Family) ->
    case family_group_label(Family) of
        <<"classic-six">> -> <<"classic-six">>;
        <<"modern-core">> -> <<"modern-core">>;
        <<"grouped-fallback">> ->
            binary:replace(renderer_key(Family), <<"fallback.">>, <<"fallback-">>)
    end.

context_for(code_analyzer) -> {<<"analysisFocus">>, <<"typed-module-contracts">>};
context_for(data_processing) -> {<<"dataWindow">>, <<"batched-stream-reconciliation">>};
context_for(jargon) -> {<<"languagePolicy">>, <<"beam-ecosystem-glossary">>};
context_for(metrics) -> {<<"signalBlend">>, <<"latency-error-saturation">>};
context_for(network_activity) -> {<<"transportMix">>, <<"beam-distribution-http-sse">>};
context_for(system_monitoring) -> {<<"telemetryScope">>, <<"runtime-build-host">>};
context_for(agent_workflows) -> {<<"coordinationMode">>, <<"beam-orchestration-handshake">>};
context_for(platform_engineering) -> {<<"platformSurface">>, <<"otp-release-lane">>};
context_for(observability_ai_runtime) -> {<<"runtimeSignals">>, <<"logs-metrics-provider-audit">>};
context_for(delivery_preview_ops) -> {<<"deliveryGuardrail">>, <<"preview-release-checkpoints">>};
context_for(supply_chain_security) -> {<<"supplyChainPosture">>, <<"artifact-integrity-attestation">>};
context_for(Family) -> {<<"fallbackFamily">>, fallback_group_name(Family)}.

list_values() ->
    #{
        <<"outputFormats">> => [<<"text">>, <<"json">>],
        <<"flags">> => [
            <<"list-values">>,
            <<"focus-family">>,
            <<"output-format">>,
            <<"seed">>,
            <<"experimental-provider">>
        ],
        <<"generatorFamilies">> => [registry_entry(Family) || Family <- all_generator_families()],
        <<"classicSix">> => [list_to_binary(family_label(Family)) || Family <- classic_six()],
        <<"modernCore">> => [list_to_binary(family_label(Family)) || Family <- modern_core()],
        <<"fallbackFamilies">> => [list_to_binary(family_label(Family)) || Family <- later_fallback()],
        <<"implementationMode">> => <<"family-focus-deterministic">>
    }.

registry_entry(Family) ->
    #{
        <<"id">> => atom_to_binary(Family, utf8),
        <<"registryId">> => list_to_binary(family_label(Family)),
        <<"rendererKey">> => renderer_key(Family),
        <<"tranche">> => tranche_for(Family)
    }.

fallback_renderer_key(Family) ->
    case fallback_group_name(Family) of
        <<"ai_governance">> -> <<"fallback.ai_governance">>;
        <<"security_blockchain">> -> <<"fallback.security_blockchain">>;
        <<"health_protocol">> -> <<"fallback.health_protocol">>;
        <<"overlay_quantum">> -> <<"fallback.overlay_quantum">>
    end.

fallback_group_name(Family) ->
    case lists:member(Family, [
        ai_inference_ops,
        evaluation_and_guardrails,
        knowledge_retrieval,
        edge_client_runtime,
        identity_and_trust,
        aibom_provenance,
        agent_boundary_security,
        embedded_agentic_pipeline,
        data_governance_compliance,
        finops_capacity
    ]) of
        true -> <<"ai_governance">>;
        false ->
            case lists:member(Family, [blockchain_protocol_ops, cross_chain_interop, proof_and_sequencer_ops]) of
                true -> <<"security_blockchain">>;
                false ->
                    case lists:member(Family, [
                        hybrid_runtime_ops,
                        capacity_cost_controller,
                        batch_execution_tuner,
                        compiler_maintainer,
                        interop_adapter_engineer,
                        preflight_capacity_planner,
                        simulator_performance_engineer
                    ]) of
                        true -> <<"overlay_quantum">>;
                        false -> <<"health_protocol">>
                    end
            end
    end.
