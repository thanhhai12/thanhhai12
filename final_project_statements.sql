-- User requirements: view all the matches and results 
SELECT dates, match_id, team1_id, team2_id, location, team1_score, team2_score,team1_pen_score, team2_pen_score, group_match FROM Matches
ORDER BY dates;


-- User requirements: View information of teams and players
SELECT Player.team_name, Player.player_name, Player.position, Player.DOB
FROM Team
JOIN Player ON Team.team_id = Player.team_id;


-- User requirements: view the matches according to 2 teams playing the match
SELECT dates, match_id, team1_id, team2_id, location, team1_score, team2_score, group_match
FROM Matches
WHERE team1_id = 'ENG' And team2_id = 'BEL';


-- User requirements: view the matches played by teams
SELECT team_id, COUNT(*) AS match_played
FROM (
    SELECT team1_id AS team_id FROM Matches
    UNION ALL
    SELECT team2_id AS team_id FROM Matches
) AS Teams
GROUP BY team_id
ORDER BY match_played DESC;



-- User requirements:  Find the most played team
WITH TeamMatches AS (
    SELECT team_id, COUNT(*) AS match_played
    FROM (
        SELECT team1_id AS team_id FROM Matches
        UNION ALL
        SELECT team2_id AS team_id FROM Matches
    ) AS Teams
    GROUP BY team_id
)
SELECT team_id, match_played
FROM (
    SELECT team_id, match_played,
           DENSE_RANK() OVER (ORDER BY match_played DESC) AS rnk
    FROM TeamMatches
) AS RankedTeams
WHERE rnk = 1;



-- User requirements: Find the winner in the a specific match 
SELECT
    match_id,
    team1_id,
    team2_id,
    team1_score,
    team2_score,
    team1_pen_score,
    team2_pen_score,
    CASE
        WHEN team1_score > team2_score THEN team1_id
        WHEN team1_score < team2_score THEN team2_id
        ELSE 
        case 
			when team1_score = team2_score then case 
			when team1_pen_score > team2_pen_score then team1_id
			when team1_pen_score < team2_pen_score then team2_id
		else
        'DRAW'
        end
		END
    END AS winning_team
FROM Matches
where team1_id = 'FRA' AND team2_id = 'ARG';


-- User requirements:  Find the champion 
SELECT
    match_id,
    team1_id,
    team2_id,
    team1_score,
    team2_score,
    team1_pen_score,
    team2_pen_score,
     CASE
        WHEN team1_score > team2_score THEN team1_id
        WHEN team1_score < team2_score THEN team2_id
        ELSE 
        case 
			when team1_score = team2_score then case 
			when team1_pen_score > team2_pen_score then team1_id
			when team1_pen_score < team2_pen_score then team2_id
		else
        'DRAW'
        end
    END 
    END AS the_champion
FROM Matches
WHERE group_match = 'final';


-- statement8: Find the top scorer
SELECT
    player_name,
    SUM(player_score) AS total_goals
FROM
    Score
GROUP BY
    player_name
ORDER BY
    total_goals DESC;
    -- statement9: rank the teams in each group match 
SELECT team_id, group_match, COALESCE(SUM(points), 0) AS total_points
FROM (
    -- Calculate points for wins
    SELECT team1_id AS team_id, team1_score AS score, group_match, 3 AS points
    FROM Matches
    WHERE team1_score > team2_score AND group_match IN ('Group B')
    UNION ALL
    SELECT team2_id AS team_id, team2_score AS score, group_match, 3 AS points
    FROM Matches
    WHERE team2_score > team1_score AND group_match IN ('Group B')
    
    UNION ALL
    
    -- Calculate points for draws
    SELECT team1_id AS team_id, team1_score AS score, group_match, 1 AS points
    FROM Matches
    WHERE team1_score = team2_score AND group_match IN ('Group B')
    UNION ALL
    SELECT team2_id AS team_id, team2_score AS score, group_match, 1 AS points
    FROM Matches
    WHERE team1_score = team2_score AND group_match IN ('Group B')
    
    UNION ALL
    
    -- Teams that lost (but didn't win or draw)
    SELECT team1_id AS team_id, team1_score AS score, group_match, 0 AS points
    FROM Matches
    WHERE team1_score < team2_score AND group_match IN ('Group B')
    UNION ALL
    SELECT team2_id AS team_id, team2_score AS score, group_match, 0 AS points
    FROM Matches
    WHERE team2_score < team1_score AND group_match IN ('Group B')
) AS team_points
GROUP BY team_id, group_match
ORDER BY group_match, total_points DESC;

-- statement 10 The player who receives the most cards
SELECT
    player_name,
    SUM(yellow_card) AS total_yellow_cards,
    SUM(red_card) AS total_red_cards,
    RANK() OVER (ORDER BY SUM(yellow_card + red_card) DESC) AS card_rank
FROM
    Card
GROUP BY
    player_name
ORDER BY
    total_yellow_cards + total_red_cards DESC;



