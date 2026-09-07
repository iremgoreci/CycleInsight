def generate_insights(
    analysis: dict,
    symptom_names: dict[int, str],
) -> list[dict]:
    """
    Generate user-friendly insights from calculated analysis results.
    """

    insights = []

    insights.extend(
        generate_cycle_insights(
            analysis.get("cycle", {})
        )
    )

    insights.extend(
        generate_prediction_insights(
            analysis.get("predictions", {})
        )
    )

    insights.extend(
        generate_bleeding_insights(
            analysis.get("bleeding", {})
        )
    )

    insights.extend(
        generate_symptom_insights(
            analysis.get("symptoms", {}),
            symptom_names,
        )
    )

    insights.extend(
        generate_wellbeing_insights(
            analysis.get("wellbeing", {})
        )
    )

    insights.extend(
        generate_correlation_insights(
            analysis.get("correlations", {})
        )
    )

    return insights


def generate_cycle_insights(
    cycle: dict,
) -> list[dict]:
    """
    Generate insights from cycle patterns.
    """

    insights = []

    cycle_lengths = cycle.get(
        "cycle_lengths",
        [],
    )

    if len(cycle_lengths) < 2:
        return insights

    # Cycle regularity

    regularity = cycle.get(
        "regularity"
    )

    if regularity == "regular":
        insights.append({
            "type": "cycle_pattern",
            "title": "Cycle pattern",
            "message": (
                "Your recorded cycle lengths "
                "appear relatively consistent."
            ),
            "priority": "low",
        })

    elif regularity == "irregular":
        insights.append({
            "type": "cycle_pattern",
            "title": "Cycle pattern",
            "message": (
                "Your recorded cycle lengths "
                "show some variation."
            ),
            "priority": "medium",
        })

    # Cycle length trend

    trend = cycle.get("trend")

    if trend:
        slope = trend.get("slope")
        r_squared = trend.get("r_squared")
        p_value = trend.get("p_value")

        if (
            slope is not None
            and r_squared is not None
            and p_value is not None
            and r_squared >= 0.5
            and p_value <= 0.05
        ):
            if slope > 0:
                insights.append({
                    "type": "cycle_trend",
                    "title": "Cycle length trend",
                    "message": (
                        "Your recorded cycle lengths "
                        "show an increasing trend over time."
                    ),
                    "priority": "low",
                })

            elif slope < 0:
                insights.append({
                    "type": "cycle_trend",
                    "title": "Cycle length trend",
                    "message": (
                        "Your recorded cycle lengths "
                        "show a decreasing trend over time."
                    ),
                    "priority": "low",
                })

    return insights


def generate_prediction_insights(
    predictions: dict,
) -> list[dict]:
    """
    Generate insights from prediction results.
    """

    insights = []

    estimated_cycle_length = predictions.get(
        "estimated_cycle_length"
    )

    confidence = predictions.get(
        "confidence"
    )

    if estimated_cycle_length is None:
        return insights

    confidence_tier = (
        confidence.get("tier")
        if confidence
        else "low"
    )

    if confidence_tier == "low":
        message = (
            f"Your estimated cycle length is "
            f"{estimated_cycle_length} days, "
            "but more cycle data is needed to make "
            "this prediction more reliable."
        )

        insights.append({
            "type": "prediction",
            "title": "Cycle prediction",
            "message": message,
            "priority": "low",
        })

    elif confidence_tier == "medium":
        message = (
            f"Your estimated cycle length is "
            f"{estimated_cycle_length} days based on "
            "your recorded cycles."
        )

        insights.append({
            "type": "prediction",
            "title": "Cycle prediction",
            "message": message,
            "priority": "medium",
        })

    elif confidence_tier == "high":
        message = (
            f"Your estimated cycle length is "
            f"{estimated_cycle_length} days based on "
            "your recorded cycles."
        )

        insights.append({
            "type": "prediction",
            "title": "Cycle prediction",
            "message": message,
            "priority": "medium",
        })

    return insights


def generate_bleeding_insights(
    bleeding: dict,
) -> list[dict]:
    """
    Generate insights from bleeding patterns.
    """

    insights = []

    period_duration = bleeding.get(
        "period_duration"
    )

    average_level = bleeding.get(
        "average_level"
    )

    peak_level = bleeding.get(
        "peak_level"
    )

    if (
        period_duration is None
        and average_level is None
        and peak_level is None
    ):
        return insights

    # Average bleeding intensity

    if (
        average_level is not None
        and average_level >= 4
    ):
        insights.append({
            "type": "bleeding_intensity",
            "title": "Bleeding intensity",
            "message": (
                "Your recorded bleeding levels "
                "were relatively high on average."
            ),
            "priority": "medium",
        })

    # Peak bleeding intensity

    if (
        peak_level is not None
        and peak_level >= 4
        and (
            average_level is None
            or average_level < 4
        )
    ):
        insights.append({
            "type": "bleeding_intensity",
            "title": "Peak bleeding level",
            "message": (
                "You recorded a high bleeding level "
                "on at least one logged day."
            ),
            "priority": "low",
        })

    return insights


def generate_symptom_insights(
    symptoms: dict,
    symptom_names: dict[int, str],
) -> list[dict]:
    """
    Generate insights from recurring symptom patterns.
    """

    insights = []

    if not symptoms:
        return insights

    recurring_symptoms = []

    for symptom_type_id, symptom_data in symptoms.items():

        if not symptom_data:
            continue

        frequency = symptom_data.get(
            "frequency"
        )

        if frequency is None:
            continue

        if frequency >= 2:
            symptom_name = symptom_names.get(
                int(symptom_type_id),
                f"Symptom {symptom_type_id}",
            )

            recurring_symptoms.append(
                (
                    symptom_name,
                    frequency,
                )
            )

    if not recurring_symptoms:
        return insights

    recurring_symptoms.sort(
        key=lambda item: item[1],
        reverse=True,
    )

    symptom_messages = []

    for symptom_name, frequency in recurring_symptoms:

        symptom_messages.append(
            f"{symptom_name} was recorded "
            f"{frequency} times."
        )

    insights.append({
        "type": "symptom_pattern",
        "title": "Recurring symptoms",
        "message": " ".join(symptom_messages),
        "priority": "low",
    })

    return insights


def generate_wellbeing_insights(
    wellbeing: dict,
) -> list[dict]:
    """
    Generate insights from wellbeing trends.
    """

    insights = []

    for metric_name, metric_data in wellbeing.items():

        if not metric_data:
            continue

        trend = metric_data.get(
            "trend"
        )

        if not trend:
            continue

        slope = trend.get(
            "slope"
        )

        r_squared = trend.get(
            "r_squared"
        )

        p_value = trend.get(
            "p_value"
        )

        if slope is None:
            continue

        if (
            r_squared is None
            or p_value is None
        ):
            continue

        if r_squared < 0.5:
            continue

        if p_value > 0.05:
            continue

        if slope > 0:
            direction = "increasing"

        elif slope < 0:
            direction = "decreasing"

        else:
            continue

        title = metric_name.capitalize()

        insights.append({
            "type": "wellbeing_trend",
            "title": f"{title} trend",
            "message": (
                f"Your recorded {metric_name} levels "
                f"show a {direction} trend."
            ),
            "priority": "low",
        })

    return insights


def generate_correlation_insights(
    correlations: dict,
) -> list[dict]:
    """
    Generate insights from recorded correlations.
    """

    insights = []

    sleep_mood = correlations.get(
        "sleep_mood"
    )

    if sleep_mood:

        correlation = sleep_mood.get(
            "correlation"
        )

        p_value = sleep_mood.get(
            "p_value"
        )

        if (
            correlation is not None
            and p_value is not None
            and abs(correlation) >= 0.5
            and p_value <= 0.05
        ):

            if correlation > 0:
                message = (
                    "Your recorded sleep quality appears "
                    "to be positively associated with "
                    "your mood."
                )

            else:
                message = (
                    "Your recorded sleep quality appears "
                    "to be negatively associated with "
                    "your mood."
                )

            insights.append({
                "type": "correlation",
                "title": "Sleep and mood",
                "message": message,
                "priority": "medium",
            })

    stress_pain = correlations.get(
        "stress_pain"
    )

    if stress_pain:

        correlation = stress_pain.get(
            "correlation"
        )

        p_value = stress_pain.get(
            "p_value"
        )

        if (
            correlation is not None
            and p_value is not None
            and abs(correlation) >= 0.5
            and p_value <= 0.05
        ):

            if correlation > 0:
                message = (
                    "Your recorded stress levels appear "
                    "to be positively associated with "
                    "your pain levels."
                )

            else:
                message = (
                    "Your recorded stress levels appear "
                    "to be negatively associated with "
                    "your pain levels."
                )

            insights.append({
                "type": "correlation",
                "title": "Stress and pain",
                "message": message,
                "priority": "medium",
            })

    return insights