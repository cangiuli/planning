/*********************************************************************

 * (C) Copyright 2008, University of Illinois, Urbana-Champaign

 *

 * All rights reserved. Use of this software is permitted ONLY for

 * non-commercial research purposes, and it may be copied only

 * for that use only. All copies must include this copyright message.

 * This software is made available AS IS, and neither the authors

 * nor the University of Illinois, make any warranty about the

 * software or its performance.

 *

 *********************************************************************/
/********************************************************************

 * File: memory.c

 * Description: modified from memory.c in LPG

 *

 * Authors:  Chih-wei Hsu and Benjamin W. Wah

 *

 *********************************************************************/
/*
# Copyright (C) 2004, Board of Trustees of the University of Illinois.
#
# The program is copyrighted by the University of Illinois, and should
# not be distributed without prior approval.  Commercialization of this 
# product requires prior licensing from the University of Illinois.
# Commercialization includes the integration of this code in part or 
# whole into a product for resale. 
#
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Author: Y. X. Chen, C. W. Hsu, and B. W. Wah, University of Illinois
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
*/

/*********************************************************************
 * (C) Copyright 2000 Albert Ludwigs University Freiburg
 *     Institute of Computer Science
 *
 * All rights reserved. Use of this software is permitted for 
 * non-commercial research purposes, and it may be copied only 
 * for that use.  All copies must include this copyright message.
 * This software is made available AS IS, and neither the authors
 * nor the  Albert Ludwigs University Freiburg make any warranty
 * about the software or its performance. 
 *********************************************************************/









/*********************************************************************
 * File: memory.c
 * Description: Creation and Deletion functions for all data structures.
 *
 * Author: Joerg Hoffmann
 *
 *********************************************************************/ 









#include "ff.h"
#include "memory.h"
#include "parse.h"







/**********************
 * CREATION FUNCTIONS *
 **********************/











/* parsing
 */









char *new_Token( int len )

{

  char *tok = ( char * ) calloc( len, sizeof( char ) );
  CHECK_PTR(tok);

  return tok;

}



TokenList *new_TokenList( void )

{

  TokenList *result = ( TokenList * ) calloc( 1, sizeof( TokenList ) );
  CHECK_PTR(result);

  result->item = NULL; 
  result->next = NULL;

  return result;

}



FactList *new_FactList( void )

{

  FactList *result = ( FactList * ) calloc( 1, sizeof( FactList ) );
  CHECK_PTR(result);

  result->item = NULL; 
  result->next = NULL;

  return result;

}



TypedList *new_TypedList( void )

{

  TypedList *result = ( TypedList * ) calloc( 1, sizeof( TypedList ) );
  CHECK_PTR(result);

  result->name = NULL; 
  result->type = NULL;
  result->n = -1;

  return result;

}



TypedListList *new_TypedListList( void )

{

  TypedListList *result = ( TypedListList * ) calloc( 1, sizeof( TypedListList ) );
  CHECK_PTR(result);

  result->predicate = NULL; 
  result->args = NULL;

  return result;

}



PlNode *new_PlNode( Connective c )

{

  PlNode *result = ( PlNode * ) calloc( 1, sizeof( PlNode ) );
  CHECK_PTR(result);

  result->connective = c;
  result->atom = NULL;
  result->sons = NULL;
  result->next = NULL;

  return result;

}

ConNode *new_ConNode( Connective_Con c )

{

  ConNode *result = ( ConNode * ) calloc( 1, sizeof( ConNode ) );
  CHECK_PTR(result);

  result->connective = c;
  result->number = result->number2 = 0;
  result->sons = NULL;
  result->sons2 = NULL;
  result->sons_c = NULL;
  result->next = NULL;

  return result;

}

PrefNode *new_PrefNode( char *name, char *opname)

{

  PrefNode *result = ( PrefNode * ) calloc( 1, sizeof( PrefNode ) );
  CHECK_PTR(result);
  
  result->name = (char *) malloc(strlen(name)+1);
  result->opname = (char *) malloc(strlen(opname)+1);
  result->weight = 0;
  strcpy(result->name, name);
  strcpy(result->opname, opname);
  result->body = NULL;
  result->next = NULL;

  return result;

}


PlOperator *new_PlOperator( char *name )

{

  PlOperator *result = ( PlOperator * ) calloc( 1, sizeof( PlOperator ) );
  CHECK_PTR(result);

  if ( name ) {
    result->name = new_Token(strlen(name)+1);
    CHECK_PTR(result->name);
    strcpy(result->name, name);
  } else {
    result->name = NULL;
  }

  result->params = NULL;
  result->preconds = NULL;
  result->effects = NULL;
  result->number_of_real_params = 0;
  result->next = NULL;

  return result;

}



PlOperator *new_axiom_op_list( void )

{

  static int count;
  char *name;
  PlOperator *ret;

  /* WARNING: count should not exceed 999 
   */
  count++;
  if ( count == 10000 ) {
    printf("\ntoo many axioms! look into memory.c, line 157\n\n");
    exit( 1 );
  }
  name = new_Token(strlen(HIDDEN_STR)+strlen(AXIOM_STR)+4+1);
  sprintf(name, "%s%s%4d", HIDDEN_STR, AXIOM_STR, count);

  ret = new_PlOperator(name);
  free(name);

  return ret;

}














/* instantiation
 */











Fact *new_Fact( void )

{

  Fact *result = ( Fact * ) calloc( 1, sizeof( Fact ) );
  CHECK_PTR(result);

  return result;

}



Facts *new_Facts( void )

{

  Facts *result = ( Facts * ) calloc( 1, sizeof( Facts ) );
  CHECK_PTR(result);

  result->fact = new_Fact();

  result->next = NULL;

  return result;

}



WffNode *new_WffNode( Connective c )

{

  WffNode *result = ( WffNode * ) calloc( 1, sizeof( WffNode ) );
  CHECK_PTR(result);

  result->connective = c;

  result->var = -1;
  result->var_type = -1;
  result->var_name = NULL;

  result->sons = NULL;
  result->next = NULL;
  result->prev = NULL;

  result->fact = NULL;
  result->NOT_p = -1;

  result->son = NULL;

  result->visited = FALSE;

  return result;

}



Literal *new_Literal( void ) 

{

  Literal *result = ( Literal * ) calloc( 1, sizeof( Literal ) );
  CHECK_PTR(result);

  result->next = NULL;
  result->prev = NULL;

  return result; 

}



Effect *new_Effect( void )

{

  Effect *result = ( Effect * ) calloc( 1, sizeof( Effect ) );
  CHECK_PTR(result);

  result->num_vars = 0;

  result->conditions = NULL;

  result->effects = NULL;

  result->next = NULL;
  result->prev = NULL;

  return result;

}



Operator *new_Operator( char *name, int norp )

{

  int i;

  Operator *result = ( Operator * ) calloc( 1, sizeof( Operator ) );
  CHECK_PTR(result);

  if ( name ) {
    result->name = new_Token( strlen( name ) + 1 );
    CHECK_PTR( result->name );
    strcpy( result->name, name );
  } else {
    result->name = NULL;
  }

  result->num_vars = 0;
  result->number_of_real_params = norp;

  for ( i = 0; i < MAX_VARS; i++ ) {
    result->removed[i] = FALSE;
  }

  result->preconds = NULL;

  result->effects = NULL;

  result->hard = TRUE;

  return result;

}



NormEffect *new_NormEffect1( Effect *e )

{

  int i;

  NormEffect *result = ( NormEffect * ) calloc( 1, sizeof( NormEffect ) );
  CHECK_PTR(result);

  result->num_vars = e->num_vars;
  for ( i = 0; i < e->num_vars; i++ ) {
    result->var_types[i] = e->var_types[i];
    result->inst_table[i] = -1;
  }

  result->conditions = NULL;
  result->num_conditions = 0;

  result->adds = NULL;
  result->num_adds = 0;
  result->dels = NULL;
  result->num_dels = 0;

  result->next = NULL;
  result->prev = NULL;

  return result;

}



NormEffect *new_NormEffect2( NormEffect *e )

{

  int i, j, a;

  NormEffect *result = ( NormEffect * ) calloc( 1, sizeof( NormEffect ) );
  CHECK_PTR(result);

  result->num_vars = 0;

  result->conditions = ( Fact * ) calloc( e->num_conditions, sizeof( Fact ) );
  result->num_conditions = e->num_conditions;
  for ( i = 0; i < e->num_conditions; i++ ) {
    result->conditions[i].predicate = e->conditions[i].predicate;
    a = ( e->conditions[i].predicate < 0 ) ? 2 : garity[e->conditions[i].predicate];
    for ( j = 0; j < a; j++ ) {
      result->conditions[i].args[j] = e->conditions[i].args[j];
    }
  }

  result->adds = ( Fact * ) calloc( e->num_adds, sizeof( Fact ) );
  result->num_adds = e->num_adds;
  for ( i = 0; i < e->num_adds; i++ ) {
    result->adds[i].predicate = e->adds[i].predicate;
    for ( j = 0; j < garity[e->adds[i].predicate]; j++ ) {
      result->adds[i].args[j] = e->adds[i].args[j];
    }
  }
  result->dels = ( Fact * ) calloc( e->num_dels, sizeof( Fact ) );
  result->num_dels = e->num_dels;
  for ( i = 0; i < e->num_dels; i++ ) {
    result->dels[i].predicate = e->dels[i].predicate;
    for ( j = 0; j < garity[e->dels[i].predicate]; j++ ) {
      result->dels[i].args[j] = e->dels[i].args[j];
    }
  }

  result->next = NULL;
  result->prev = NULL;

  return result;

}



NormOperator *new_NormOperator( Operator *op )

{

  int i;

  NormOperator *result = ( NormOperator * ) calloc( 1, sizeof( NormOperator ) );
  CHECK_PTR(result);

  result->operator = op;

  result->num_vars = op->num_vars;
  for ( i = 0; i < op->num_vars; i++ ) {
    result->var_types[i] = op->var_types[i];
    result->inst_table[i] = -1;
  }
  result->num_removed_vars = 0;

  result->preconds = NULL;
  result->num_preconds = 0;

  result->effects = NULL;

  return result;

}




EasyTemplate *new_EasyTemplate( NormOperator *op )

{

  EasyTemplate *result = ( EasyTemplate * ) calloc( 1, sizeof( EasyTemplate ) );
  CHECK_PTR(result);

  result->op = op;

  result->prev = NULL;
  result->next = NULL;

  return result;

}



MixedOperator *new_MixedOperator( Operator *op )

{

  MixedOperator *result = ( MixedOperator * ) calloc( 1, sizeof( MixedOperator ) );
  CHECK_PTR(result);

  result->operator = op;

  result->preconds = NULL;
  result->num_preconds = 0;

  result->effects = NULL;

  return result;

}



PseudoActionEffect *new_PseudoActionEffect( void )

{

  PseudoActionEffect *result = 
    ( PseudoActionEffect * ) calloc( 1, sizeof( PseudoActionEffect ) );
  CHECK_PTR(result);

  result->conditions = NULL;
  result->num_conditions = 0;

  result->adds = NULL;
  result->num_adds = 0;
  result->dels = NULL;
  result->num_dels = 0;

  result->next = NULL;

  return result;

}



PseudoAction *new_PseudoAction( MixedOperator *op )

{

  int i;

  PseudoAction *result = ( PseudoAction * ) calloc( 1, sizeof( PseudoAction ) );
  CHECK_PTR(result);

  result->operator = op->operator;
  for ( i = 0; i < op->operator->num_vars; i++ ) {
    result->inst_table[i] = op->inst_table[i];
  }

  result->preconds = op->preconds;
  result->num_preconds = op->num_preconds;

  result->effects = NULL;
  result->num_effects = 0;

  return result;

}



Action *new_Action( void )

{

  Action *result = ( Action * ) calloc( 1, sizeof( Action ) );
  CHECK_PTR(result);

  result->norm_operator = NULL;
  result->pseudo_action = NULL;

  result->next = NULL;

  return result;

}



EhcNode *new_EhcNode( void )

{

  EhcNode *result = ( EhcNode * ) calloc( 1, sizeof( EhcNode ) );
  CHECK_PTR(result);

  result->father = NULL;
  result->next = NULL;

  result->new_goal = -1;

  return result;

}



EhcHashEntry *new_EhcHashEntry( void )

{

  EhcHashEntry *result = ( EhcHashEntry * ) calloc( 1, sizeof( EhcHashEntry ) );
  CHECK_PTR(result);

  result->ehc_node = NULL;

  result->next = NULL;

  return result;

}



PlanHashEntry *new_PlanHashEntry( void )

{

  PlanHashEntry *result = ( PlanHashEntry * ) calloc( 1, sizeof( PlanHashEntry ) );
  CHECK_PTR(result);

  result->next_step = NULL;

  result->next = NULL;

  return result;

}



BfsNode *new_BfsNode( void )

{

  BfsNode *result = ( BfsNode * ) calloc( 1, sizeof( BfsNode ) );
  CHECK_PTR(result);

  result->father = NULL;
  result->next = NULL;
  result->prev = NULL;

  return result;

}



BfsHashEntry *new_BfsHashEntry( void )

{

  BfsHashEntry *result = ( BfsHashEntry * ) calloc( 1, sizeof( BfsHashEntry ) );
  CHECK_PTR(result);

  result->bfs_node = NULL;

  result->next = NULL;

  return result;

}











/**********************
 * DELETION FUNCTIONS *
 **********************/












void free_TokenList( TokenList *source )

{

  if ( source ) {
    free_TokenList( source->next );
    if ( source->item ) {
      free( source->item );
    }
    free( source );
  }

}



void free_FactList( FactList *source )

{

  if ( source ) {
    free_FactList( source->next );
    free_TokenList( source->item );
    free( source );
  }

}



void free_PlNode( PlNode *node )

{
  
  if ( node ) {
    free_PlNode( node->sons );
    free_PlNode( node->next );
    free_TokenList( node->atom );
    free( node );
  }

}



void free_PlOperator( PlOperator *o )

{

  if ( o ) {
    free_PlOperator( o->next );

    if ( o->name ) {
      free( o->name );
    }
    
    free_FactList( o->params );
    free_PlNode( o->preconds );
    free_PlNode( o->effects );

    free( o );
  }

}



void free_Operator( Operator *o )

{

  if ( o ) {

    if ( o->name ) {
      free( o->name );
    }

    free( o );
  } 

}



void free_WffNode( WffNode *w )

{

  return;
  if ( w ) {
    free_WffNode( w->son );
    free_WffNode( w->sons );
    free_WffNode( w->next );
    if ( w->var_name ) {
      free( w->var_name );
    }
    if ( w->fact ) {
      free( w->fact );
    }
    free( w );
  }

}



void free_NormEffect( NormEffect *e )

{

  if ( e ) {
    free_NormEffect( e->next );

    if ( e->conditions ) {
      free( e->conditions );
    }
    if ( e->adds ) {
      free( e->adds );
    }
    if ( e->dels ) {
      free( e->dels );
    }

    free( e );
  }

}



void free_partial_Effect( Effect *e )

{

  if ( e ) {
    free_partial_Effect( e->next );

    free_WffNode( e->conditions );

    free( e );
  }

}



void free_NormOperator( NormOperator *o )

{

  if ( o ) {

    if ( o->preconds ) {
      free( o->preconds );
    }

    free_NormEffect( o->effects );

    free( o );
  }

}



void free_single_NormEffect( NormEffect *e )

{

  if ( e ) {
    if ( e->conditions ) {
      free( e->conditions );
    }
    if ( e->adds ) {
      free( e->adds );
    }
    if ( e->dels ) {
      free( e->dels );
    }

    free( e );
  }

}



void free_single_EasyTemplate( EasyTemplate *t )

{

  if ( t ) {
    free( t );
  }

}



void free_TypedList( TypedList *t )

{

  if ( t ) {
    if ( t->name ) {
      free( t->name );
      t->name = NULL;
    }
    if ( t->type ) {
      free_TokenList( t->type );
      t->type = NULL;
    }
    free_TypedList( t->next );

    free( t );
  }

}



void free_TypedListList( TypedListList *t )

{

  if ( t ) {
    if ( t->predicate ) {
      free( t->predicate );
      t->predicate = NULL;
    }
    if ( t->args ) {
      free_TypedList( t->args );
      t->args = NULL;
    }
    free_TypedListList( t->next );

    free( t );
  }

}

TypedList *copy_TypedList(TypedList *p)
{
  TypedList *t = NULL;
  if (p)
  {
    t = new_TypedList();
    if (p->name)
    {
      t->name = (char *) malloc(strlen(p->name)+1);
      strcpy(t->name, p->name);
    }
    else
      t->name = NULL;
    t->type = copy_TokenList(p->type);
    t->n = p->n;
    t->next = copy_TypedList(p->next);
  }
  return t;
}

PlNode *copy_PlNode(PlNode *p)
{
  PlNode *t = NULL;
  if (p && p->value != -1)
  {
    t = new_PlNode(p->connective);
    t->parse_vars = copy_TypedList(p->parse_vars);
    t->atom = copy_TokenList(p->atom);
    t->sons = copy_PlNode(p->sons);
    t->next = copy_PlNode(p->next);
    t->value = p->value;  
  }
  return t;
}
