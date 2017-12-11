/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Bean;

import Interface.Procedure.Proc;
import static Interface.Procedure.Proc.*;
import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleTypes;

/**
 *
 * @author Loyd
 */
public class BeanBDAccessProcedure extends BeanBDAccess {
    
    public BeanBDAccessProcedure(String log, String mdp, SGBD baseDeDonnee) {
        super(log, mdp, baseDeDonnee);
        
        //CreateProcedure();
    }
   
    @Override
    public String executeRequete(String tableName, String columnName, String condition) throws SQLException
    {
        int cpt;
        String resultat = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    resultat = new String();
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    if( condition == null)
                        rs = instruc.executeQuery("select " + columnName + " from " + tableName);
                    else
                        rs = instruc.executeQuery("select " + columnName + " from " + tableName + " where " + condition);

                    while(rs.next())
                    {
                        cpt = 1;
                        while(cpt-1 < rs.getMetaData().getColumnCount())
                        {
                            resultat += rs.getString(cpt);
                            cpt++;
                        }
                    }
                }

            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }    
        
        return resultat;
    } 
    
    @Override
    public String[] executeRequete(String requete) throws SQLException
    {
        int cpt = 1;
        String resultat = null;
        String []ret = null;
        
        if(driver != null)
        {
            try
            {
                if(login != null && driver != null)
                {
                    synchronized(this)
                    {
                        resultat = new String();
                        connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
                        instruc = connect.createStatement();

                        rs = instruc.executeQuery(requete);

                        while(rs.next())
                        {
                            cpt = 1;
                            while(cpt-1 < rs.getMetaData().getColumnCount())
                            {
                                resultat += rs.getString(cpt) + "&&";
                                cpt++;
                            }
                        }

                        if(cpt != 1)
                        {
                            ret = new String[cpt];
                            ret = resultat.split("&&");
                        }
                    }     
                }
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
        
        return ret;
    }
    
    @Override
    public String executeInsert(String requete) throws SQLException
    {
        String resultat = null;
        
        if(driver != null)
        {
             try
            {
                if(login != null && driver != null)
                {
                    synchronized(this)
                    {
                        resultat = new String();
                        connect = DriverManager.getConnection("jdbc:oracle:thin:cb@//localhost:1521/orcl", login, motDePasse);
                        instruc = connect.createStatement();

                        instruc.executeUpdate(requete);
                    }     
                }
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
        
        return resultat;
    }
    
    @Override
    public void executeUpdate(String tableName, String columnName, String update, String condition) throws SQLException
    {       
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    if(condition == null)
                        instruc.executeUpdate("update " + tableName + " set " + columnName + " = " + columnName + update);
                    else
                        instruc.executeUpdate("update " + tableName + " set " + columnName + " = " + columnName + update + " where " + condition);
                } 
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
    }
    
    @Override
    public void executeUpdate(String requete) throws SQLException
    {
        if(driver != null)
        {
            try
            {
                if(login != null)
                {
                    connect = DriverManager.getConnection("jdbc:oracle:thin:BD@//localhost:1521/orcl", login, motDePasse);
                    instruc = connect.createStatement();

                    instruc.executeUpdate(requete);     
                }
            }

            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                if (connect != null )
                    connect.close();
            }
        }
    }
    
    public String readCommentaire(int idUser, String idFilm)
    {
        String resultat = null;
        
        try
        {
            resultat = new String();
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(ReadCommentaire));

            call.setInt(1, idUser);
            call.setInt(2, Integer.parseInt(idFilm));
            call.registerOutParameter(3, OracleTypes.VARCHAR);

            call.executeQuery();
            
            resultat = call.getString(3);
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
        
        return resultat;
    }
    
    public int readNumber(String idFilm)
    {
        int resultat = 0;
        
        try
        {
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(ReadNumber));

            call.setInt(1, Integer.parseInt(idFilm));
            call.registerOutParameter(2, OracleTypes.INTEGER);

            call.executeQuery();
            
            resultat = call.getInt(2);
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
        
        return resultat;
    }
    
    public int readVote(int idUser, String idFilm)
    {
        int resultat = 0;
        
        try
        {
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(ReadVote));

            call.setInt(1, idUser);
            call.setInt(2, Integer.parseInt(idFilm));
            call.registerOutParameter(3, OracleTypes.INTEGER);

            call.executeQuery();
            
            resultat = call.getInt(3);
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
        
        return resultat;
    }
    
    public String executeProcedure(String contrainte)
    {
        String resultat = null;
        int cpt = 0;
        
        try
        {
            resultat = new String();
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(Login));

            call.setObject(1, contrainte);
                
            call.registerOutParameter(2, OracleTypes.INTEGER);

            call.executeQuery();
            
            resultat = String.valueOf(call.getInt(2));
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }

        return resultat;
    }
    
    public void executeProcedure(String var, int idUser, String idFilm, Proc proc)
    {
        try
        {
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(proc));

            if(proc == Vote)
                call.setInt(1, Integer.parseInt(var));
            else
                call.setString(1, var);
            
            call.setInt(2, idUser);
            call.setInt(3, Integer.parseInt(idFilm));

            call.executeQuery();
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }
    }
    
    public ResultSet executeProcedure(String contrainte, Proc proc)
    {
        try
        {
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(proc));

            if(proc == RechercheId)
                call.setInt(1, Integer.parseInt(contrainte));
            else
                call.setObject(1, contrainte);
                
            call.registerOutParameter(2,  OracleTypes.CURSOR);

            call.executeQuery();
            
            rs = (ResultSet) call.getObject(2);
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }

        return rs;
    }
    
    public ResultSet executeProcedure(String[] acteur, String[]rea, String date, String temps)
    {
        Object[] ret = null;
        int cpt = 0;
        
        try
        {
            connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
            CallableStatement call = connect.prepareCall(getProcedure(RechercheFilm));
            
            if(acteur != null)
                call.setArray(1, ((OracleConnection)connect).createARRAY("ACTORS_NAME", acteur));
            else
                call.setNull(1, OracleTypes.ARRAY, "ACTORS_NAME");
            
            if(rea != null)
                call.setArray(2, ((OracleConnection)connect).createARRAY("REALISATORS_T", rea));
            else
                call.setNull(2, OracleTypes.ARRAY, "REALISATORS_T");
            
            if(date != null)
            {
                call.setString(3, date);
                call.setString(4, temps);
            }    
            else
            {
                call.setNull(3, OracleTypes.VARCHAR);
                call.setNull(4, OracleTypes.VARCHAR);
            }
                
            call.registerOutParameter(5, OracleTypes.CURSOR);
            
            call.executeQuery();
            
            rs = (ResultSet) call.getObject(5);

            /*if(rs != null)
                ret = new Object[rs.getRow()];
            
            while(rs.next())
            {
                cpt = 1;

                while(cpt-1 < rs.getMetaData().getColumnCount())
                {
                    ret[cpt-1] = rs.getObject(cpt);
                    cpt++;
                }
            }*/
        }
        
        catch(SQLException e)
        {
            System.out.println("Erreur !!! " + e.getMessage());
        }

        return rs;
    }
    
    private void CreateProcedure()
    {
        if(driver != null)
        {
            try
            {
                System.out.println("Log : " + login + " mot de passe : " + motDePasse);
                connect = DriverManager.getConnection("jdbc:oracle:thin:BD_SOCIETE@//localhost:1521/orcl", login, motDePasse);
                instruc = connect.createStatement();
                //instruc.executeUpdate("drop procedure if exists Recherche");
            }
            
            catch (SQLException e)
            {
                System.out.println("Erreur !!! " + e.getMessage());
            }

            finally
            {
                try
                {
                    if (connect != null )
                        connect.close();
                }
                
                catch(SQLException e)
                {
                    System.out.println("Erreur !!! " + e.getMessage());
                }
            }
        }
    }
    
    private String getProcedure(Proc proc)
    {
        switch(proc)
        {
            case RechercheId: return "{call RechercheID(?, ?)}";
                
            case Login: return "{call LoginUser(?, ?)}";
            
            case RechercheNom: return "{call RechercheNom(?, ?)}";
            
            case RechercheActeur: return "{call RechercheActeur(?, ?)}";
            
            case RechercheDateB: return "{call RechercheDateB(?, ?)}";
            
            case RechercheDateA: return "{call RechercheDateA(?, ?)}";
            
            case RechercheDateE: return "{call RechercheDateE(?, ?)}";
            
            case RechercheFilm: return "{call RechercheFilm(?, ?, ?, ?, ?)}";
            
            case Vote: return "{call ProcVote(?, ?, ?)}";
            
            case Commentaire: return "{call ProcCommentaire(?, ?, ?)}";
            
            case ReadCommentaire: return "{call ReadCommentaire(?, ?, ?)}";
            
            case ReadVote: return "{call ReadVote(?, ?, ?)}";
            
            case ReadNumber: return "{call ReadNumber(?, ?)}";
        }
        
        return null;
    }
}
